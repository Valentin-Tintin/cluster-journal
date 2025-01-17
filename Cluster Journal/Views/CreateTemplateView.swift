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
        Form {
            TextField("Name", text: self.$name)
            Button("Save", action: save)
        }
        
    }
    
    func save() {
        var newSection = EntryAtributeSection(context: viewContext)
        newSection.name = name
        saveSection(newSection)
    }
    
    
}

struct CreateTemplateView: View {
    var templateType: TemplateType

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State var newTemplate: Template?
    @State var sections: Dictionary<String,EntryAtributeSection> = Dictionary<String,EntryAtributeSection>()
    @State var addSectionViewOpen: Bool = false
    @Binding var finished: Bool
    
    
    init(templ: TemplateType, finished: Binding<Bool> ) {
        self._finished = finished
        self.templateType = templ
        self._newTemplate = State(initialValue: nil)
        var arr = Array(sections.map(){
            return ($0.key, $0.value)
        })
        
    }
        
    var body: some View {
        
        Form {
            Section(header: Text("Standard")){
                HStack(alignment: VerticalAlignment.center) {
                    Text("Zeitpunkt")
                    Text("Date").foregroundColor(.gray)
                }
            }
            ForEach(Array(sections.map(){
                return ($0.key, $0.value)
            }), id: \.0) { section in
               
                    EntryAttributesView(sectionName: section.0, saveAttrToSection: addAttrToSection,attributes: section.1.attributes)
                }
            
            Button("Add Section", action: openAddSectionView)
                .onAppear(perform: initTemplate)
            Button("Save", action: saveTemplate)
        }
        .navigationBarTitle(Text(templateType.name ?? "No Name"))
        
        .sheet(isPresented: self.$addSectionViewOpen) {
            AddSectionView(saveSection: addSection)
        }
        
           
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
        templ.name = templateType.name ?? "Mein Test Name"
        self.newTemplate = templ
    }
    
    func saveTemplate(){
        print("saving Template")
        self.newTemplate?.type = self.templateType
        self.newTemplate?.sections = Set(self.sections.values)
        self.presentationMode.wrappedValue.dismiss()
        self.finished = true
        try? viewContext.save()
        
        
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
               
        Section(header: Text(sectionName)){
        
        ForEach(Array(attributes)) { attribute in
            HStack(alignment: VerticalAlignment.center) {
                Text(attribute.name ?? "")
                Text(attribute.type.rawValue).foregroundColor(.gray)
            }
        }
        
        
        Button("Add Attribute", action: handleAddAttr)
            .sheet(isPresented: $isAddAttributeViewOpen) {
                CreateAttrView(saveAttr: saveAttr) .environment(\.managedObjectContext, viewContext)
                
            }
        }
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
