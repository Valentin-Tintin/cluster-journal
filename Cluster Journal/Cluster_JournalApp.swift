//
//  Cluster_JournalApp.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 17.12.20.
//

import SwiftUI

//Dies ist ein Test

@main
struct Cluster_JournalApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            JournalListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct Cluster_JournalApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
