//
//  LogbuchEntry.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 17.12.20.
//

import SwiftUI
import CoreData

struct LogbuchEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var superEntry : SuperJournalEntry
    
    @FetchRequest var typedEntry : FetchedResults<DefaultJournalEntry>
    
    init(superEntry : SuperJournalEntry) {
        self.superEntry = superEntry
        let predicate = NSPredicate(format: "id = %@", superEntry.id?.uuidString ?? "")
        let sortdesc = [NSSortDescriptor(key: "timestamp", ascending: true)]
        let request = FetchRequest<DefaultJournalEntry>(entity: DefaultJournalEntry.entity(), sortDescriptors: sortdesc, predicate: predicate)
    
        self._typedEntry = request
    }
    	
   	var body: some View {
            VStack {
                Text(typedEntry.first?.typeDiscriminator.rawValue ?? JournalEntryType.Default.rawValue )
                Text(typedEntry.first?.notes ?? "default value")
                Text(typedEntry.first?.timestamp?.toString() ?? "No date found")
                Button("delete_debug",action: deleteItem)
            }
        
    }
    
    private func deleteItem() {
        viewContext.delete(superEntry)
        try? viewContext.save()
    }
}

/*struct LogbuchEntry_Previews: PreviewProvider {
    static var previews: some View {
        //LogbuchEntryView(entry: LogbuchEntry)
    }
}
 */