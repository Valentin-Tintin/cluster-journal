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
            print(res?.count)
            print("Creating Default Template")
            let defaultTemplateType = createDefaultTemplate(context: context)
            
            let section = EntryAtributeSection(context: context)
            
            section.name = "Standard"
            
            let ortAttribut = EntryAttribute(context: context)
            ortAttribut.name = "Datum"
            ortAttribut.type = .Date

            let set = Set<EntryAttribute>([ortAttribut])
            
            
            
            section.attributes = set
            
            let templ = Template(context: context)
            templ.name = "Default"
            templ.type = defaultTemplateType
            let sections = Set<EntryAtributeSection>([section])
            templ.sections = sections
            templ.isDefault = true
            
            do {
               try context.save()
            } catch {
                print("Error Saving")
            }
            
        }
        
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
