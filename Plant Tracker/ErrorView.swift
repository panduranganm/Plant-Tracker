import SwiftUI

struct ErrorView: View {
    let error: Error?
    let message: String
    let retryAction: (() -> Void)?
    
    init(error: Error? = nil, message: String = "Something went wrong", retryAction: (() -> Void)? = nil) {
        self.error = error
        self.message = message
        self.retryAction = retryAction
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
                .padding(.bottom, 4)
            
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            if let errorMessage = error?.localizedDescription {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    Text("Try Again")
                        .fontWeight(.medium)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    VStack(spacing: 20) {
        ErrorView(message: "Failed to load plants", retryAction: {})
        
        ErrorView(error: NSError(domain: "PlantTracker", code: 404, userInfo: [NSLocalizedDescriptionKey: "Network connection failed"]), 
                 message: "Unable to save photo", 
                 retryAction: {})
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
