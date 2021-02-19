//
//  JournalListView.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 06.02.21.
//

import SwiftUI
import CoreData

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
    
    init() {
        let request: NSFetchRequest<TopLevelEntry> = NSFetchRequest(entityName: "TopLevelEntry")
        request.fetchLimit = 3
        request.predicate = NSPredicate.all
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TopLevelEntry.timestamp_, ascending: false)]
        self._entries = FetchRequest<TopLevelEntry>(fetchRequest: request)
    }
    
    
    var body: some View {
        NavigationView {
            GeometryReader {
                reader in
                VStack(alignment: HorizontalAlignment.leading, spacing: 30) {
                    VStack(alignment: HorizontalAlignment.leading, spacing: 10) {
                        ForEach(entries) { entry in
                            EntryOverview(entry: entry)
                            //JournalListItemView(entry: entry).environment(\.managedObjectContext, viewContext)
                        }
                        NavigationLink(destination: CompleteJournalView()){
                            Text("Alle anzeigen")
                        }
                    }
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: HorizontalAlignment.leading){
                        
                        ForEach(templates) { template in
                            
                                NavigationLink(destination: CreateFromTemplateView(template: template)){
                                    HStack(alignment: VerticalAlignment.center) {
                                        VStack(alignment: HorizontalAlignment.leading, spacing: 10) {
                                            Image(systemName: template.type?.icon ?? "")
                                                .foregroundColor(Color.orange)
                                            Text( template.name ?? "No name found")
                                                .lineLimit(1)
                                                .foregroundColor(Color.black)
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                                        .padding()
                                        VStack(alignment: HorizontalAlignment.trailing) {
                                            Image(systemName: "plus.circle")
                                                .foregroundColor(Color.black)
                                        }.padding()
                                        
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
                                    .compositingGroup()
                                    .shadow(color: Color.gray, radius: 1)
                                }
                        }
                        NavigationLink(destination: CreateNamedTemplateView()){
                            HStack(alignment: VerticalAlignment.center) {
                            VStack(alignment: HorizontalAlignment.leading) {
                               
                                    Text("Eigene Vorlage erstellen")
                                        .font(.callout)
                                        .foregroundColor(Color.black)
                                        .lineLimit(2)
                                   
                                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                                VStack(alignment: HorizontalAlignment.trailing){
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(Color.black)
                                }
                            }
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
                        .compositingGroup()
                        .shadow(color: Color.gray, radius: 1)
                            
                        }
                    }
                }.padding()
                Spacer()
            }
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
