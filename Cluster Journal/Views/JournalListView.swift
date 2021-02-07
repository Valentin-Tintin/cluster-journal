//
//  JournalListView.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 06.02.21.
//

import SwiftUI

struct JournalListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \LogbuchEntry.timestamp, ascending: true)], predicate: NSPredicate.all) var entries: FetchedResults<LogbuchEntry>
    
    
    var body: some View {
        Button("degug_add", action: createEntry)
        ForEach(entries) { entry in
            LogbuchEntryView(entry: entry)
        }
    }
    
    private func createEntry() {
        var newItem = LogbuchEntry(context: viewContext)
        newItem.id = UUID()
        newItem.notes = "Notiz für \(newItem.id?.uuidString ?? "keine ID gefunden")"
        newItem.mask = true
        newItem.timestamp = Date()
        try? viewContext.save()
    }
}

/*
struct JournalListView_Previews: PreviewProvider {
    static var previews: some View {
        JournalListView()
    }
}
 */
