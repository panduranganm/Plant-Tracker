//
//  Plant_TrackerApp.swift
//  Plant Tracker
//
//  Created by Maya P on 4/1/25.
//

import SwiftUI

@main
struct Plant_TrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
