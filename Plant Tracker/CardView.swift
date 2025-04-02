import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = 12
    var shadowOpacity: Double = 0.1
    var shadowRadius: CGFloat = 5
    var backgroundColor: Color = Color(.systemBackground)
    
    init(
        cornerRadius: CGFloat = 12,
        shadowOpacity: Double = 0.1,
        shadowRadius: CGFloat = 5,
        backgroundColor: Color = Color(.systemBackground),
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.cornerRadius = cornerRadius
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        content
            .padding()
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(shadowOpacity), radius: shadowRadius, x: 0, y: 2)
    }
}

// Flippable card animation
struct FlippableCardView<Front: View, Back: View>: View {
    var front: Front
    var back: Back
    @Binding var isFlipped: Bool
    var onFlip: (() -> Void)? = nil
    
    init(isFlipped: Binding<Bool>, @ViewBuilder front: () -> Front, @ViewBuilder back: () -> Back, onFlip: (() -> Void)? = nil) {
        self._isFlipped = isFlipped
        self.front = front()
        self.back = back()
        self.onFlip = onFlip
    }
    
    var body: some View {
        ZStack {
            front
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .accessibility(hidden: isFlipped)
            
            back
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -180),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .accessibility(hidden: !isFlipped)
        }
        .onTapGesture {
            withAnimation(.spring()) {
                isFlipped.toggle()
                if let onFlip = onFlip {
                    onFlip()
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CardView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Monstera")
                    .font(.headline)
                Text("Living Room")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        let isFlipped = Binding.constant(false)
        FlippableCardView(isFlipped: isFlipped) {
            // Front of card
            VStack {
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .padding()
                Text("Tap to see details")
                    .font(.caption)
            }
            .frame(width: 200, height: 200)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        } back: {
            // Back of card
            VStack(alignment: .leading, spacing: 12) {
                Text("Photo Details")
                    .font(.headline)
                Text("Date: April 1, 2025")
                Text("Notes: Looking healthy!")
            }
            .frame(width: 200, height: 200)
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(12)
        }
    }
    .padding()
}
