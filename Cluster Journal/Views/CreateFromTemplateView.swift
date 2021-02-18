//
//  CreateFromTemplateView.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 15.02.21.
//

import SwiftUI
import CoreData
import Combine

struct CreateFromTemplateView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    var template: Template
    
    @State var entry: TopLevelEntry?
    
    init(template: Template) {
       
        self.template = template
        self._entry = State(wrappedValue: nil)
    }
    
    var body: some View {
        
        Form {
            Text("Create new \(entry?.type?.name ?? "No name found")")
            let  sections = entry?.sections ?? []
            Section(header: Text("Standard")){
                DatePicker("Zeitpunkt", selection: Binding(get: {self.entry?.timestamp ?? Date()}, set: {self.entry?.timestamp = $0}))
            }
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
        .onDisappear(perform: removeItem)
        
    }
    
    func removeItem() {
        if(self.entry != nil){
            viewContext.delete(self.entry!)
        }
        
    }
    
    func createEmptyEntryFromTemplate() {
        print("Sections from templ")
        print(self.template.type?.name)
        self.entry = TopLevelEntry.fromTemplate(template: self.template, context: viewContext)
    }
    
    func saveState(){
        entry?.sections.map(){
            $0.attributes.map(){
                print("\($0.name): \($0.dateValue)")
            }
        }
        try? viewContext.save()
        self.entry = nil
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditAttributeValueView: View {
    @State var value: EntryAttribute
    @State var numberText: String = ""
    
    var body: some View {
        switch value.type {
        case ValueType.Date:
            DatePicker(value.name ?? "", selection: Binding(get: {value.dateValue ?? Date()}, set: {value.dateValue = $0}))
        case ValueType.Boolean:
            Toggle(value.name ?? "", isOn: $value.boolValue)
        case ValueType.Numeric:
            TextField(value.name ?? "", text: $numberText)
                        .keyboardType(.numberPad)
                        .onReceive(Just(numberText)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.numberText = filtered
                                self.value.numericValue = Int32(filtered) ?? 0
                            }
                    }
        case ValueType.String:
            TextField(value.name ?? "", text: Binding(get: {value.stringValue ?? ""}, set: {value.stringValue = $0}))
        
        default:
            Text("No Type Found")
        }
    }
}


