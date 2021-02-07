//
//  PublicTransportJournalDetailView.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 07.02.21.
//

import SwiftUI
import CoreData


struct PublicTransportJournalDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var superEntry : SuperJournalEntry
    
    @FetchRequest var typedEntry : FetchedResults<PublicTransportJournalEntry>
    
    init(superEntry : SuperJournalEntry) {
        self.superEntry = superEntry
        let predicate = NSPredicate(format: "id = %@", superEntry.id?.uuidString ?? "")
        let sortdesc = [NSSortDescriptor(key: "timestamp", ascending: true)]
        let request = FetchRequest<PublicTransportJournalEntry>(entity: PublicTransportJournalEntry.entity(), sortDescriptors: sortdesc, predicate: predicate)
    
        self._typedEntry = request
    }
        
       var body: some View {
        
            VStack {
                Text("ÖPNV")
                Text(typedEntry.first?.notes ?? "default value")
                Text(typedEntry.first?.timestamp?.toString() ?? "No date found")
                Button("delete_debug",action: deleteItem)
            }
        
    }
    
    private func deleteItem() {
        viewContext.delete(typedEntry.first!)
        try? viewContext.save()
    }
}
