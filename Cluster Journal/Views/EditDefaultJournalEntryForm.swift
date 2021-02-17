//
//  EditDefaultJournalEntryForm.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 07.02.21.
//

import SwiftUI
import CoreData

struct EditDefaultJournalEntryForm: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State var entry: DefaultJournalEntry
    @State var temp_entry: DefaultJournalEntry = DefaultJournalEntry()
    var shouldCreate = false
    
    init(initialEntry: DefaultJournalEntry?) {
        if(initialEntry == nil){
            print("Should Create")
            self.shouldCreate = true;
            let newEntry = DefaultJournalEntry()
            self._temp_entry = State(initialValue: newEntry )
            self._entry = State(initialValue: newEntry )
        } else {
            let defaulEntry = initialEntry!
            self._entry = State(initialValue: defaulEntry)
            self._temp_entry = State(initialValue: defaulEntry)
        }
        
    }
    
    
    
    
    
    var body: some View {
        Form {
            DatePicker("Datum", selection: $temp_entry.timestamp)
            Toggle("Maske", isOn: $temp_entry.mask)
            Toggle("Draußen", isOn: $temp_entry.outside)
            TextField("Notizen", text: $temp_entry.notes)
        }.environment(\.managedObjectContext, viewContext)
        Button("save", action: saveChanges)
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    
    private func handleSaveButton() {
        print(_temp_entry)
    }
    
    private func saveChanges(){
        self.entry.mask = temp_entry.mask
    }
}

