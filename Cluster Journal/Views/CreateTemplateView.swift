//
//  CreateTemplateView.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 17.02.21.
//

import SwiftUI

struct AddSectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var saveSection: (_: EntryAtributeSection) -> Void;
    @State var name: String = ""
    var body: some View {
        TextField("Name", text: self.$name)
        Button("Save", action: save)
    }
    
    func save() {
        var newSection = EntryAtributeSection(context: viewContext)
        newSection.name = name
        saveSection(newSection)
    }
    
    
}

struct CreateTemplateView: View {
    var templateType: TemplateType?
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State var newTemplate: Template?
    @State var sections: Dictionary<String,EntryAtributeSection> = Dictionary<String,EntryAtributeSection>()
    @State var addSectionViewOpen: Bool = false
    
    
    init() {
        self.templateType = nil
        self._newTemplate = State(initialValue: nil)
        var arr = Array(sections.map(){
            return ($0.key, $0.value)
        })
        
    }
    
    var body: some View {
        Text(templateType?.name ?? "No Name")
        Form {
            ForEach(Array(sections.map(){
                return ($0.key, $0.value)
            }), id: \.0) { section in
                Section(header: Text(section.1.name ?? "")){
                    EntryAttributesView(sectionName: section.0, saveAttrToSection: addAttrToSection,attributes: section.1.attributes)
                }
            }
        }
        
        .sheet(isPresented: self.$addSectionViewOpen) {
            AddSectionView(saveSection: addSection)
        }
        Button("Add Section", action: openAddSectionView)
            .onAppear(perform: initTemplate)
        Button("Save", action: saveTemplate)
    }
    
    func addAttrToSection(sectionKEy: String, attr: EntryAttribute){
        var exsistingSection = self.sections[sectionKEy]
        if(exsistingSection == nil){
            //ignore
        } else {
            var existingAttributes = exsistingSection?.attributes
            
                exsistingSection?.addToAttributes_(attr)
                self.sections.updateValue(exsistingSection!, forKey: sectionKEy)
                
            
        }
        
        
    }
    
    
    func initTemplate() {
        var templ = Template(context: viewContext)
        templ.name = templateType?.name ?? "Mein Test Name"
        self.newTemplate = templ
    }
    
    func saveTemplate(){
        self.newTemplate?.sections = Set(self.sections.values)
        try? viewContext.save()
        presentationMode.wrappedValue.dismiss()
    }
    func openAddSectionView(){
        self.addSectionViewOpen = true
    }
    
    func addSection(section : EntryAtributeSection) -> Void {
        
        self.sections.updateValue(section, forKey: section.name!)
        addSectionViewOpen.toggle()
    }
}

struct EntryAttributesView: View {
    let sectionName: String
    var saveAttrToSection : (_ : String, _: EntryAttribute) -> Void
    @Environment(\.managedObjectContext) private var viewContext
    @State var attributes: Set<EntryAttribute>
    @State var isAddAttributeViewOpen: Bool = false
    @State var name: String = ""
    var body: some View {
               
        
        ForEach(Array(attributes)) { attribute in
            HStack(alignment: VerticalAlignment.center) {
                Text(attribute.name ?? "")
                Text(attribute.type.rawValue).foregroundColor(.gray)
            }
            
        }
        
        .sheet(isPresented: $isAddAttributeViewOpen) {
            CreateAttrView(saveAttr: saveAttr) .environment(\.managedObjectContext, viewContext)
            
        }
        Button("Add Attribute", action: handleAddAttr)
    }
    
    func saveAttr(attr: EntryAttribute) {
        attributes.insert(attr)
        saveAttrToSection(sectionName, attr)
        isAddAttributeViewOpen.toggle()
    }
    
    func handleAddAttr(){
        isAddAttributeViewOpen.toggle()
    }
}

struct CreateAttrView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var name: String = ""
    @State var type: ValueType = ValueType.String
    var saveAttr: (_: EntryAttribute) -> Void
    
    var body: some View {
        Form{
            TextField("Name", text: $name)
            Picker("Type", selection: $type){
                ForEach(ValueType.allCases, id: \.self) { vType in
                    Text(vType.rawValue)
                }
            }.pickerStyle(InlinePickerStyle())
            Button("Save", action: handleSave)
        }
        
    }
    func handleSave() {
        let newAttr = EntryAttribute(context: viewContext)
        print(self.type.rawValue)
        newAttr.name = name
        newAttr.type = type
        saveAttr(newAttr)
    }
}
