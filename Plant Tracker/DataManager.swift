import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    private let persistenceController = PersistenceController.shared
    
    private init() {}
    
    // MARK: - Plant CRUD Operations
    
    func createPlant(customName: String, scientificName: String? = nil, location: String? = nil) -> Plant? {
        let context = persistenceController.container.viewContext
        let plant = Plant(context: context)
        plant.customName = customName
        plant.scientificName = scientificName
        plant.location = location
        plant.creationDate = Date()
        
        do {
            try context.save()
            return plant
        } catch {
            print("Error creating plant: \(error)")
            context.rollback()
            return nil
        }
    }
    
    func fetchPlants() -> [Plant] {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Plant.creationDate, ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching plants: \(error)")
            return []
        }
    }
    
    func updatePlant(_ plant: Plant, customName: String? = nil, scientificName: String? = nil, location: String? = nil) -> Bool {
        let context = persistenceController.container.viewContext
        
        if let customName = customName {
            plant.customName = customName
        }
        plant.scientificName = scientificName
        plant.location = location
        
        do {
            try context.save()
            return true
        } catch {
            print("Error updating plant: \(error)")
            context.rollback()
            return false
        }
    }
    
    func deletePlant(_ plant: Plant) -> Bool {
        let context = persistenceController.container.viewContext
        context.delete(plant)
        
        do {
            try context.save()
            return true
        } catch {
            print("Error deleting plant: \(error)")
            context.rollback()
            return false
        }
    }
    
    // MARK: - Photo CRUD Operations
    
    func addPhoto(to plant: Plant, imagePath: String, notes: String? = nil) -> Photo? {
        let context = persistenceController.container.viewContext
        let photo = Photo(context: context)
        photo.imagePath = imagePath
        photo.dateTaken = Date()
        photo.notes = notes
        photo.plant = plant
        
        do {
            try context.save()
            return photo
        } catch {
            print("Error adding photo: \(error)")
            context.rollback()
            return nil
        }
    }
    
    func fetchPhotos(for plant: Plant) -> [Photo] {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "plant == %@", plant)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Photo.dateTaken, ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching photos: \(error)")
            return []
        }
    }
    
    func updatePhoto(_ photo: Photo, notes: String?) -> Bool {
        let context = persistenceController.container.viewContext
        photo.notes = notes
        
        do {
            try context.save()
            return true
        } catch {
            print("Error updating photo: \(error)")
            context.rollback()
            return false
        }
    }
    
    func deletePhoto(_ photo: Photo) -> Bool {
        let context = persistenceController.container.viewContext
        context.delete(photo)
        
        do {
            try context.save()
            return true
        } catch {
            print("Error deleting photo: \(error)")
            context.rollback()
            return false
        }
    }
}
