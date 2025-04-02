import SwiftUI

struct PlantListItemView: View {
    let plant: Plant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plant.customName ?? "Unnamed Plant")
                        .font(.headline)
                    
                    if let location = plant.location {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.gray)
                            Text(location)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if let scientificName = plant.scientificName {
                        Text(scientificName)
                            .font(.caption)
                            .italic()
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                if let photos = plant.photos?.allObjects as? [Photo],
                   let mostRecentPhoto = photos.sorted(by: { ($0.dateTaken ?? Date()) > ($1.dateTaken ?? Date()) }).first {
                    AsyncImage(url: URL(string: mostRecentPhoto.imagePath ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image(systemName: "leaf.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.green)
                }
            }
            
            Divider()
        }
        .padding(.horizontal)
    }
}

#Preview {
    let previewContext = PersistenceController.preview.container.viewContext
    let plant = Plant(context: previewContext)
    plant.customName = "Monstera"
    plant.scientificName = "Monstera deliciosa"
    plant.location = "Living Room"
    plant.creationDate = Date()
    
    return PlantListItemView(plant: plant)
        .previewLayout(.sizeThatFits)
}