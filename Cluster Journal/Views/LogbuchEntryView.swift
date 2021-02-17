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
    @State var superEntry : SuperJournalEntry
    
    @FetchRequest<DefaultJournalEntry> var typedEntry : FetchedResults<DefaultJournalEntry>
    
    init(_ superEntry : SuperJournalEntry) {
        _superEntry = State(initialValue: superEntry)
        let predicate = NSPredicate(format: "id = %@", superEntry.id!.uuidString)
        print("Id in init of LogbuchEntryView \(superEntry.id?.uuidString)")
        let sortdesc = [NSSortDescriptor(keyPath: \DefaultJournalEntry.timestamp_, ascending: true)]
        
    
        _typedEntry = FetchRequest(entity: DefaultJournalEntry.entity(), sortDescriptors: sortdesc, predicate: predicate, animation :.easeIn)
        print(_typedEntry)
    }
    	
   	var body: some View {
            VStack {
                Text(_typedEntry.wrappedValue.first!.typeDiscriminator.rawValue  )
                Text(typedEntry.first?.notes ?? "default value")
                Text(typedEntry.first?.timestamp.toString() ?? "No date found")
                Button("delete_debug",action: deleteItem)
                
                NavigationLink(destination: EditDefaultJournalEntryForm(initialEntry: _typedEntry.wrappedValue.first)){
                        Text("Edit")
                  
                }
            }.navigationBarTitle("Test")
        
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
