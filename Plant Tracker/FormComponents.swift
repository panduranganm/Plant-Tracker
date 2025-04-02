import SwiftUI

struct FormTextField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    let isRequired: Bool
    
    init(_ label: String, text: Binding<String>, placeholder: String = "", isRequired: Bool = false) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.isRequired = isRequired
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text(label)
                    .foregroundColor(.primary)
                if isRequired {
                    Text("*")
                        .foregroundColor(.red)
                }
            }
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.words)
        }
    }
}

struct FormTextEditor: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .foregroundColor(.primary)
            
            TextEditor(text: $text)
                .frame(height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .overlay(
                    Group {
                        if text.isEmpty {
                            Text(placeholder)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8)
                        }
                    },
                    alignment: .topLeading
                )
        }
    }
}

struct FormSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
            
            content
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    @State var text = ""
    
    return VStack(spacing: 20) {
        FormSection("Plant Details") {
            FormTextField("Plant Name", text: .constant(""), placeholder: "Enter plant name", isRequired: true)
            FormTextField("Scientific Name", text: .constant(""), placeholder: "Enter scientific name")
            FormTextEditor(label: "Notes", text: .constant(""), placeholder: "Enter any notes about your plant...")
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}