import SwiftUI

struct PhotoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var photo: Photo
    @State private var isEditing = false
    @State private var notes = ""
    var onDelete: (() -> Void)? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Photo Display
                    AsyncImage(url: URL(string: photo.imagePath ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ZStack {
                            Color.gray.opacity(0.1)
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                                .font(.largeTitle)
                        }
                    }
                    .frame(maxHeight: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    // Photo Details
                    FormSection("Photo Details") {
                        VStack(alignment: .leading, spacing: 12) {
                            if let dateTaken = photo.dateTaken {
                                DetailRow(label: "Date Taken", value: dateTaken.formatted(date: .long, time: .shortened))
                            }
                            
                            if let notes = photo.notes, !notes.isEmpty {
                                DetailRow(label: "Notes", value: notes)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Photo Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button("Edit") {
                            notes = photo.notes ?? ""
                            isEditing = true
                        }
                        if let onDelete = onDelete {
                            Button(role: .destructive) {
                                onDelete()
                                dismiss()
                            } label: {
                                Text("Delete")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            NavigationView {
                EditPhotoView(photo: photo, notes: $notes)
            }
        }
    }
}

struct EditPhotoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var photo: Photo
    @Binding var notes: String
    
    var body: some View {
        Form {
            FormSection("Photo Details") {
                FormTextEditor(label: "Notes", text: $notes, placeholder: "Add notes about this photo...")
            }
        }
        .navigationTitle("Edit Photo")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    savePhoto()
                    dismiss()
                }
            }
        }
    }
    
    private func savePhoto() {
        photo.notes = notes.isEmpty ? nil : notes
        try? viewContext.save()
    }
}

#Preview {
    let previewContext = PersistenceController.preview.container.viewContext
    let photo = Photo(context: previewContext)
    photo.imagePath = "https://example.com/photo.jpg"
    photo.dateTaken = Date()
    photo.notes = "Test photo notes"
    
    return PhotoDetailView(photo: photo)
}