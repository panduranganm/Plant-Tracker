import SwiftUI

struct RefreshableScrollView<Content: View>: View {
    var content: Content
    var onRefresh: () async -> Void
    @State private var isRefreshing = false
    
    init(@ViewBuilder content: @escaping () -> Content, onRefresh: @escaping () async -> Void) {
        self.content = content()
        self.onRefresh = onRefresh
    }
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                if #available(iOS 15.0, *) {
                    // Use native refreshable on iOS 15+
                    content
                        .refreshable {
                            await onRefresh()
                        }
                } else {
                    // Custom implementation for earlier iOS versions
                    MovingView(isRefreshing: $isRefreshing, onRefresh: onRefresh)
                    
                    content
                        .offset(y: isRefreshing ? 50 : 0)
                }
            }
        }
    }
}

// Custom pull-to-refresh implementation for iOS < 15
private struct MovingView: View {
    @Binding var isRefreshing: Bool
    let onRefresh: () async -> Void
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            if offset > 30 && !isRefreshing {
                Spacer()
                    .onAppear {
                        isRefreshing = true
                        Task {
                            await onRefresh()
                            isRefreshing = false
                        }
                    }
            }
            HStack {
                Spacer()
                if isRefreshing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Image(systemName: "arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .rotationEffect(.degrees(offset > 30 ? 180 : 0))
                        .animation(.easeInOut, value: offset > 30)
                }
                Spacer()
            }
            .offset(y: -30 + (isRefreshing ? 30 : min(offset, 30)))
            .opacity(isRefreshing ? 1 : min(Double(offset)/30.0, 1.0))
        }
        .frame(height: 0)
    }
}

#Preview {
    RefreshableScrollView {
        VStack(spacing: 20) {
            ForEach(1..<10) { i in
                Text("Item \(i)")
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
            }
        }
        .padding()
    } onRefresh: {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 2_000_000_000)
    }
}
