import XCTest
@testable import Plant_Tracker
import CoreData

class DataManagerTests: XCTestCase {
    var dataManager: DataManager!
    var persistenceController: PersistenceController!
    
    override func setUpWithError() throws {
        // Create an in-memory persistent store for testing
        persistenceController = PersistenceController(inMemory: true)
        dataManager = DataManager.shared
    }
    
    override func tearDownWithError() throws {
        persistenceController = nil
        dataManager = nil
    }
    
    func testCreatePlant() throws {
        // Given
        let customName = "Test Plant"
        let scientificName = "Testus Plantus"
        let location = "Living Room"
        
        // When
        let plant = dataManager.createPlant(customName: customName, scientificName: scientificName, location: location)
        
        // Then
        XCTAssertNotNil(plant)
        XCTAssertEqual(plant?.customName, customName)
        XCTAssertEqual(plant?.scientificName, scientificName)
        XCTAssertEqual(plant?.location, location)
        XCTAssertNotNil(plant?.creationDate)
    }
    
    func testFetchPlants() throws {
        // Given
        let plant1 = dataManager.createPlant(customName: "Plant 1")
        let plant2 = dataManager.createPlant(customName: "Plant 2")
        
        // When
        let plants = dataManager.fetchPlants()
        
        // Then
        XCTAssertEqual(plants.count, 2)
        XCTAssertTrue(plants.contains(where: { $0.customName == "Plant 1" }))
        XCTAssertTrue(plants.contains(where: { $0.customName == "Plant 2" }))
    }
    
    func testUpdatePlant() throws {
        // Given
        let plant = dataManager.createPlant(customName: "Original Name")
        let newName = "Updated Name"
        
        // When
        let success = dataManager.updatePlant(plant!, customName: newName)
        
        // Then
        XCTAssertTrue(success)
        XCTAssertEqual(plant?.customName, newName)
    }
    
    func testDeletePlant() throws {
        // Given
        let plant = dataManager.createPlant(customName: "To Be Deleted")
        
        // When
        let success = dataManager.deletePlant(plant!)
        let plants = dataManager.fetchPlants()
        
        // Then
        XCTAssertTrue(success)
        XCTAssertEqual(plants.count, 0)
    }
    
    func testAddPhotoToPlant() throws {
        // Given
        let plant = dataManager.createPlant(customName: "Plant with Photo")
        let imagePath = "test/path/image.jpg"
        let notes = "Test photo notes"
        
        // When
        let photo = dataManager.addPhoto(to: plant!, imagePath: imagePath, notes: notes)
        
        // Then
        XCTAssertNotNil(photo)
        XCTAssertEqual(photo?.imagePath, imagePath)
        XCTAssertEqual(photo?.notes, notes)
        XCTAssertEqual(photo?.plant, plant)
    }
    
    func testFetchPhotos() throws {
        // Given
        let plant = dataManager.createPlant(customName: "Plant with Photos")
        _ = dataManager.addPhoto(to: plant!, imagePath: "photo1.jpg")
        _ = dataManager.addPhoto(to: plant!, imagePath: "photo2.jpg")
        
        // When
        let photos = dataManager.fetchPhotos(for: plant!)
        
        // Then
        XCTAssertEqual(photos.count, 2)
    }
}
