//
//  LiveTrackerApp.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 26/06/2021.
//

import SwiftUI

@main
struct LiveTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
