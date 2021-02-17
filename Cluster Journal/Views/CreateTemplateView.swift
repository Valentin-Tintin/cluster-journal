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
    @State var newTemplate: Template?
    @State var sections: Set<EntryAtributeSection> = Set<EntryAtributeSection>()
    @State var addSectionViewOpen: Bool = false
    
    
    init() {
        self.templateType = nil
        self._newTemplate = State(initialValue: nil)
    }
    
    var body: some View {
        Text(templateType?.name ?? "No Name")
       
        ForEach(Array(sections)) { section in
            Text(section.name ?? "")
        }
        .sheet(isPresented: self.$addSectionViewOpen) {
            AddSectionView(saveSection: addSection)
        }
        Button("Add Section", action: openAddSectionView)
            .onAppear(perform: initTemplate)
    }
    
    
    func initTemplate() {
        var templ = Template(context: viewContext)
        templ.name = templateType?.name ?? "Mein Test Name"
        self.newTemplate = templ
    }
    
    func saveTemplate(){
        try? viewContext.save()
    }
    func openAddSectionView(){
        self.addSectionViewOpen = true
    }
    
    func addSection(section : EntryAtributeSection) -> Void {
            self.sections.insert(section)
        addSectionViewOpen.toggle()
    }
}

struct CreateTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTemplateView()
    }
}
