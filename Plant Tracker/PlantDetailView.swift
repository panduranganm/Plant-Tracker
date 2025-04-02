import SwiftUI

struct PlantDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var plant: Plant
    @State private var showingPhotoDetail = false
    @State private var selectedPhoto: Photo?
    @State private var isEditingPlant = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Plant Info Section
                FormSection("Plant Information") {
                    VStack(alignment: .leading, spacing: 12) {
                        DetailRow(label: "Name", value: plant.customName ?? "Unnamed Plant")
                        if let scientific = plant.scientificName {
                            DetailRow(label: "Scientific Name", value: scientific)
                        }
                        if let location = plant.location {
                            DetailRow(label: "Location", value: location)
                        }
                    }
                }
                
                // Photos Section
                FormSection("Photos") {
                    if let photos = plant.photos?.allObjects as? [Photo], !photos.isEmpty {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                            ForEach(photos) { photo in
                                PhotoThumbnailView(photo: photo)
                                    .onTapGesture {
                                        selectedPhoto = photo
                                        showingPhotoDetail = true
                                    }
                            }
                        }
                    } else {
                        EmptyStateView(
                            systemImage: "photo",
                            title: "No Photos",
                            message: "Add photos to track your plant's growth"
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle(plant.customName ?? "Plant Details")
        .toolbar {
            Button("Edit") {
                isEditingPlant = true
            }
        }
        .sheet(isPresented: $isEditingPlant) {
            NavigationView {
                EditPlantView(plant: plant)
            }
        }
        .sheet(isPresented: $showingPhotoDetail) {
            if let photo = selectedPhoto {
                PhotoDetailView(photo: photo)
            }
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
        }
    }
}

struct EditPlantView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var plant: Plant
    
    @State private var customName: String
    @State private var scientificName: String
    @State private var location: String
    
    init(plant: Plant) {
        self.plant = plant
        _customName = State(initialValue: plant.customName ?? "")
        _scientificName = State(initialValue: plant.scientificName ?? "")
        _location = State(initialValue: plant.location ?? "")
    }
    
    var body: some View {
        Form {
            FormSection("Plant Details") {
                FormTextField("Name", text: $customName, isRequired: true)
                FormTextField("Scientific Name", text: $scientificName)
                FormTextField("Location", text: $location)
            }
        }
        .navigationTitle("Edit Plant")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    savePlant()
                    dismiss()
                }
            }
        }
    }
    
    private func savePlant() {
        plant.customName = customName
        plant.scientificName = scientificName.isEmpty ? nil : scientificName
        plant.location = location.isEmpty ? nil : location
        
        try? viewContext.save()
    }
}

#Preview {
    let previewContext = PersistenceController.preview.container.viewContext
    let plant = Plant(context: previewContext)
    plant.customName = "Monstera"
    plant.scientificName = "Monstera deliciosa"
    plant.location = "Living Room"
    plant.creationDate = Date()
    
    return NavigationView {
        PlantDetailView(plant: plant)
    }
}
