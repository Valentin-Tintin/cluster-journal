//
//  Cluster_JournalApp.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 17.12.20.
//

import SwiftUI

@main
struct Cluster_JournalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
