//
//  ContentView.swift
//  Plant Tracker
//
//  Created by Maya P on 4/1/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAddPlant = false
    @State private var showingPhotoOptions = false
    @State private var selectedPhoto: Photo?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Plant.creationDate, ascending: false)],
        animation: .default)
    private var plants: FetchedResults<Plant>
    
    var body: some View {
        NavigationStack {
            ZStack {
                if plants.isEmpty {
                    EmptyStateView(
                        systemImage: "leaf.circle",
                        title: "No Plants Yet",
                        message: "Add your first plant to start tracking its growth journey",
                        action: { showingAddPlant = true },
                        actionTitle: "Add Plant"
                    )
                } else {
                    List {
                        ForEach(plants) { plant in
                            NavigationLink(destination: PlantDetailView(plant: plant)) {
                                PlantListItemView(plant: plant)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        // Refresh Core Data fetch
                        viewContext.refreshAllObjects()
                    }
                }
            }
            .navigationTitle("My Plants")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingPhotoOptions = true }) {
                        Image(systemName: "plus")
                    }
                }
                
                if !plants.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingAddPlant) {
                NavigationStack {
                    AddPlantView()
                }
            }
            .sheet(item: $selectedPhoto) { photo in
                NavigationStack {
                    PhotoDetailView(
                        photo: photo,
                        onDelete: {
                            if let context = photo.managedObjectContext {
                                context.delete(photo)
                                try? context.save()
                            }
                        }
                    )
                }
            }
            .actionSheet(isPresented: $showingPhotoOptions) {
                ActionSheet(
                    title: Text("Add New"),
                    message: Text("Choose an option"),
                    buttons: [
                        .default(Text("Add Plant")) { showingAddPlant = true },
                        .default(Text("Take Photo")) { /* Camera implementation coming soon */ },
                        .default(Text("Choose from Library")) { /* Photo picker implementation coming soon */ },
                        .cancel()
                    ]
                )
            }
        }
    }
    

}

struct AddPlantView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var customName = ""
    @State private var scientificName = ""
    @State private var location = ""
    @State private var notes = ""
    
    var body: some View {
        Form {
            FormSection("Plant Details") {
                FormTextField("Plant Name", text: $customName, placeholder: "Enter plant name", isRequired: true)
                FormTextField("Scientific Name", text: $scientificName, placeholder: "Enter scientific name")
                FormTextField("Location", text: $location, placeholder: "Where is this plant located?")
                FormTextEditor(label: "Notes", text: $notes, placeholder: "Enter any notes about your plant...")
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Add Plant")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    savePlant()
                }
                .disabled(customName.isEmpty)
            }
        }
    }
    
    private func savePlant() {
        let plant = Plant(context: viewContext)
        plant.customName = customName
        plant.scientificName = scientificName.isEmpty ? nil : scientificName
        plant.location = location.isEmpty ? nil : location
        plant.creationDate = Date()
        
        try? viewContext.save()
        dismiss()
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
