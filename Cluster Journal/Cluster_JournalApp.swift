//
//  Cluster_JournalApp.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 17.12.20.
//

import SwiftUI
import CoreData
//Dies ist ein Test

@main
struct Cluster_JournalApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            JournalListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear(perform: initData)
        }
    }
    
    private func initData() {
        let context = self.persistenceController.container.viewContext
        let pred = NSPredicate(format: "isDefault == YES")
        let req = NSFetchRequest<Template>(entityName: "Template")
        req.predicate = pred
        let res = try? context.fetch(req)
        
        if(res?.isEmpty ?? true ){
            print("Creating Default Template")
            let defaultTemplateType = createDefaultTemplate(context: context)
            
            let section = EntryAtributeSection(context: context)
            
            section.name = "Standard"
            
            let ortAttribut = EntryAttribute(context: context)
            ortAttribut.name = "Ort"
            ortAttribut.type = .String
            
            let maskenAttribut = EntryAttribute(context: context)
            maskenAttribut.name = "Masken"
            maskenAttribut.type = .Boolean

            let set = Set<EntryAttribute>([ortAttribut,maskenAttribut])
            
            
            
            section.attributes = set
            
            let templ = Template(context: context)
            templ.name = "Standard"
            templ.type = defaultTemplateType
            let sections = Set<EntryAtributeSection>([section])
            templ.sections = sections
            templ.isDefault = true
            
            createopnvTemplate(context: context)
            
            
            do {
               try context.save()
            } catch {
                print("Error Saving")
            }
            
        }
        
    }
    
    private func createopnvTemplate(context: NSManagedObjectContext) -> Template {
        let opnvTemplType = TemplateType(context: context)
        opnvTemplType.isDefault = true
        opnvTemplType.name = "ÖPNV"
        opnvTemplType.color = "blue"
        opnvTemplType.icon = "tram"
        
        let section = EntryAtributeSection(context: context)
        
        section.name = "Standard"
        
        let ortAttribut = EntryAttribute(context: context)
        ortAttribut.name = "Einstieg"
        ortAttribut.type = .String
        
        let maskenAttribut = EntryAttribute(context: context)
        maskenAttribut.name = "Masken"
        maskenAttribut.type = .Boolean
        
        let linieAttribut = EntryAttribute(context: context)
        linieAttribut.name = "Linie"
        linieAttribut.type = .String
        
        

        let set = Set<EntryAttribute>([ortAttribut,linieAttribut,maskenAttribut])
        
        let extrasection = EntryAtributeSection(context: context)
        
        let personenAttribut = EntryAttribute(context: context)
        personenAttribut.name = "Anzahl Personen"
        personenAttribut.type = .Numeric
        
        extrasection.name = "Extras"
        
        extrasection.attributes = Set([personenAttribut])
        
        section.attributes = set
        
        let templ = Template(context: context)
        templ.name = "ÖPNV"
        templ.type = opnvTemplType
        let sections = Set<EntryAtributeSection>([section, extrasection])
        templ.sections = sections
        templ.isDefault = true
        
        return templ
    }
    
    private func createDefaultTemplate(context: NSManagedObjectContext) -> TemplateType {
        let defaultTemplType = TemplateType(context: context)
        defaultTemplType.isDefault = true
        defaultTemplType.name = "Default-Name"
        defaultTemplType.color = "orange"
        defaultTemplType.icon = "person.3"
        defaultTemplType.isDefault = true
        
        //try? context.save()
        
        return defaultTemplType
        
    }
}

struct Cluster_JournalApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
