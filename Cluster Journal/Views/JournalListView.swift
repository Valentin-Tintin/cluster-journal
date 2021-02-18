//
//  JournalListView.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 06.02.21.
//

import SwiftUI

struct TopLevelEntryView: View {
    var entry: TopLevelEntry
    var body: some View {
        Text(entry.type?.name ?? "NO VALUE")
    }
}

struct CreateNamedTemplateView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State var creationFinished: Bool = false
    @State var name: String = ""
    @State var templ : TemplateType?
    var body: some View {
        TextField("Name", text: Binding(get: {templ?.name ?? ""}, set: {self.templ?.name = $0 }))
            .onAppear(perform: initData)
        NavigationLink("Add Template", destination: CreateTemplateView(templ: self.templ ?? TemplateType(), finished: $creationFinished))
            .onChange(of: creationFinished, perform: maybeDismissView)
        
    }
    
    func maybeDismissView(val: Bool){
        if(self.creationFinished){
            presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    func initData(){
        self.templ = TemplateType(context: viewContext)
        self.templ?.color = "orange"
        self.templ?.icon = "person.3"
    }
}

struct JournalListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate.all) var entries: FetchedResults<TopLevelEntry>
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate.all) var templates: FetchedResults<Template>
    
    var body: some View {
        NavigationView {
            VStack(alignment: HorizontalAlignment.leading, spacing: 10) {
               
                ForEach(entries) { entry in
                    EntryOverview(entry: entry)
                    //JournalListItemView(entry: entry).environment(\.managedObjectContext, viewContext)
                }
                ForEach(templates) { template in
                    NavigationLink(destination: CreateFromTemplateView(template: template)){
                        Text( "Create \(template.name ?? "No name found")")
                    }
                    

                }
                
                
                    NavigationLink(destination: CreateNamedTemplateView()){
                        Text( "Create New Template")
                    }
                    
                
                Spacer()
                Button("degug_add_default", action: createEntry)
                Divider()
                Button("degug_add_öpnv", action: createPublicTransportEntry)
               
            }.padding()
            
        }
        
    }
    
    private func createEntryFromTemplate(template: Template) -> () -> () {
        return {
            let newEntry = TopLevelEntry(context: viewContext)
            let sections: Set<EntryAtributeSection> = template.sections
            sections.map {print($0.name)}
            newEntry.sections = sections
            print(newEntry.sections ?? "No data")
        }
        
        
    }
    
    private func createEntry() {
        let newItem = DefaultJournalEntry(context: viewContext)
        newItem.typeDiscriminator = .Default

        newItem.id = UUID()
        newItem.notes = "DefaultJournal Entry"
        newItem.mask = true
        newItem.timestamp_ = Date()
        try? viewContext.save()
    }
    
    private func createPublicTransportEntry() {
        let newItem = PublicTransportJournalEntry(context: viewContext)
        newItem.id = UUID()
        newItem.typeDiscriminator = .PublicTransport
        newItem.notes = "ÖPNV Entry (\(newItem.id?.uuidString ?? "No uid found")"
        newItem.code = "RB3"
        newItem.timestamp_ = Date()
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
