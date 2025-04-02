import SwiftUI

enum StatusType {
    case loading
    case success
    case error
    
    var systemImage: String {
        switch self {
        case .loading: return "hourglass"
        case .success: return "checkmark.circle"
        case .error: return "exclamationmark.triangle"
        }
    }
    
    var color: Color {
        switch self {
        case .loading: return .blue
        case .success: return .green
        case .error: return .red
        }
    }
}

struct StatusOverlayView: View {
    let type: StatusType
    let message: String
    let dismissAfter: Double?
    var onDismiss: (() -> Void)? = nil
    
    @State private var isShowing = true
    @State private var opacity: Double = 0
    
    init(type: StatusType, message: String, dismissAfter: Double? = 2.0, onDismiss: (() -> Void)? = nil) {
        self.type = type
        self.message = message
        self.dismissAfter = dismissAfter
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        ZStack {
            if isShowing {
                VStack(spacing: 12) {
                    if type == .loading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding(.bottom, 4)
                    } else {
                        Image(systemName: type.systemImage)
                            .font(.system(size: 28))
                            .foregroundColor(type.color)
                    }
                    
                    Text(message)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                )
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.2)) {
                        opacity = 1.0
                    }
                    
                    if let dismissAfter = dismissAfter {
                        DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    private func dismiss() {
        withAnimation(.easeOut(duration: 0.2)) {
            opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isShowing = false
            onDismiss?() 
        }
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        
        VStack(spacing: 30) {
            StatusOverlayView(type: .loading, message: "Loading plants...")
            StatusOverlayView(type: .success, message: "Plant saved successfully")
            StatusOverlayView(type: .error, message: "Failed to save photo")
        }
    }
}
