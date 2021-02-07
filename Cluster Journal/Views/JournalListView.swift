//
//  JournalListView.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 06.02.21.
//

import SwiftUI

struct JournalListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \SuperJournalEntry.timestamp, ascending: true)], predicate: NSPredicate.all) var entries: FetchedResults<SuperJournalEntry>
    
    
    var body: some View {
        NavigationView {
            VStack {
                Button("degug_add_default", action: createEntry)
                Button("degug_add_öpnv", action: createPublicTransportEntry)
                ForEach(entries) { entry in
                    JournalListItemView(entry: entry)
                }
            }
            
        }
        
    }
    
    private func createEntry() {
        let newItem = DefaultJournalEntry(context: viewContext)
        newItem.id = UUID()
        newItem.notes = "DefaultJournal Entry"
        newItem.mask = true
        newItem.timestamp = Date()
        try? viewContext.save()
    }
    
    private func createPublicTransportEntry() {
        let newItem = PublicTransportJournalEntry(context: viewContext)
        newItem.id = UUID()
        newItem.typeDiscriminator = .PublicTransport
        newItem.notes = "ÖPNV Entry (\(newItem.id?.uuidString ?? "No uid found")"
        newItem.code = "RB3"
        newItem.timestamp = Date()
        print(newItem)
        do {
            try viewContext.save()
        } catch {
            print("Error saving")
        }
        
    }
}

/*
struct JournalListView_Previews: PreviewProvider {
    static var previews: some View {
        JournalListView()
    }
}
 */
