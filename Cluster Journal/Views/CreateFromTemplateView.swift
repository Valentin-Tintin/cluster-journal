//
//  CreateFromTemplateView.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 15.02.21.
//

import SwiftUI
import CoreData

struct CreateFromTemplateView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var template: Template
    
    @State var entry: TopLevelEntry?
    
    init(template: Template) {
        self.template = template
        self._entry = State(wrappedValue: nil)
    }
    
    var body: some View {
        
        Form {
            Text("Create new \(template.name ?? "No name found")")
            let  sections = entry?.sections ?? []
            ForEach(Array(sections)) { section in
                Section(header: Text(section.name ?? "Kein Name angegeben")) {
                    ForEach(Array(section.attributes)){ attr in
                        EditAttributeValueView(value: attr)
                      //  TextField(attr.name ?? "" ,text: Binding(get: {attr.type ?? ""}, set: {attr.type = $0} ))
                    }
                }
                    
                
                
            }
            Button("Save", action: saveState)
        }.onAppear(perform: createEmptyEntryFromTemplate)
        
    }
    
    func createEmptyEntryFromTemplate() {
        self.entry = TopLevelEntry.fromTemplate(template: self.template, context: viewContext)
    }
    
    func saveState(){
        entry?.sections.map(){
            $0.attributes.map(){
                print("\($0.name): \($0.dateValue)")
            }
        }
        try? viewContext.save()
    }
}

struct EditAttributeValueView: View {
    @State var value: EntryAttribute
    
    var body: some View {
        switch value.type {
        case ValueType.Date:
            DatePicker("Date", selection: Binding(get: {value.dateValue ?? Date()}, set: {value.dateValue = $0}))
        default:
            Text("String")
        }
    }
}


