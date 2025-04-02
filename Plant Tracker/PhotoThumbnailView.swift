import SwiftUI

struct PhotoThumbnailView: View {
    let photo: Photo
    let size: CGFloat
    
    init(photo: Photo, size: CGFloat = 100) {
        self.photo = photo
        self.size = size
    }
    
    var body: some View {
        VStack(spacing: 4) {
            AsyncImage(url: URL(string: photo.imagePath ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ZStack {
                    Color.gray.opacity(0.1)
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                }
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            if let dateTaken = photo.dateTaken {
                Text(dateTaken, style: .date)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    let previewContext = PersistenceController.preview.container.viewContext
    let photo = Photo(context: previewContext)
    photo.imagePath = "https://example.com/photo.jpg"
    photo.dateTaken = Date()
    photo.notes = "Test photo"
    
    return PhotoThumbnailView(photo: photo)
        .previewLayout(.sizeThatFits)
}