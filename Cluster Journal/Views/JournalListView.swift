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
        self.templ?.color = getRandomColor()
        self.templ?.icon = getSemiRandomIcon()
    }
    
    // THIS VODOO Should be replaced by picker
    
    func getRandomColor() -> String {
        let colors = ["orange","blue","green","red","yellow","purple"]
        return colors[Int.random(in: 0 ..< colors.count)]
    }
    
    func getSemiRandomIcon() -> String {
        if(self.name == "ÖPNV"){
            return "tram"
        }
        if(self.name == "Einkaufen"){
            return "cart"
        }
        let icons = ["person.3","cart", "car", "tram", "airplane", "bubble.left.and.bubble.right", "heart.text.square"]
        return icons[Int.random(in: 0 ..< icons.count)]
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
                ZStack {
                    Color("BackgroundColor")
                        .ignoresSafeArea()
                GeometryReader {
                    reader in
                    VStack(alignment: HorizontalAlignment.leading, spacing: 10) {
                        Text("Einträge").font(.headline)
                        VStack(alignment: HorizontalAlignment.leading, spacing: 10){
                            
                            ForEach(entries) { entry in
                                EntryOverview(entry: entry)
                                Divider()
                                //JournalListItemView(entry: entry).environment(\.managedObjectContext, viewContext)
                            }.padding(.horizontal)
                            NavigationLink(destination: CompleteJournalView()){
                                Text("Alle anzeigen")
                            }.padding(.horizontal)
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color.white))
                        
                        Text("Vorlagen").font(.headline)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: HorizontalAlignment.leading){
                            
                            ForEach(templates) { template in
                                
                                NavigationLink(destination: CreateFromTemplateView(template: template)){
                                    HStack(alignment: VerticalAlignment.center) {
                                        VStack(alignment: HorizontalAlignment.leading, spacing: 10) {
                                            Image(systemName: template.type?.icon ?? "")
                                                .foregroundColor(Color.fromString(str: template.type?.color ?? ""))
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
                                    //.shadow(color: Color.gray, radius: 1)
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
                    }.padding(.horizontal)
                    Spacer()
                }.navigationBarTitle(Text("Home"))
            }}
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
