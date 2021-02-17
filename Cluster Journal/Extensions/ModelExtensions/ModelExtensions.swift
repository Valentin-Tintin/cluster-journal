//
//  Extensions.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 07.02.21.
//

import Foundation
import CoreData


enum JournalEntryType: String {
    case Default
    case PublicTransport
}


extension SuperJournalEntry {
    var typeDiscriminator: JournalEntryType {
        get {
            return JournalEntryType(rawValue: self.typeDiscriminator_ ?? JournalEntryType.Default.rawValue) ?? .Default
        }
        
        set {
            self.typeDiscriminator_ = newValue.rawValue
        }
    }
    
    var timestamp: Date {
        // should never be nil
        // still shoud be checked in production
        get { timestamp_!}
        set { timestamp_ = newValue}
    }
    
    var notes: String {
        get { notes_ ?? ""}
        set { notes_ = newValue}
    }
    
}

extension Template {
    func addSection(section: EntryAtributeSection){
        var old = self.sections
        old.insert(section)
    }
    
    
    var sections: Set<EntryAtributeSection> {
        get {
            if (self.sections_ == nil) {
                return Set<EntryAtributeSection>()
            }
            return self.sections_ as! Set<EntryAtributeSection>
        }
        
        set {
            self.sections_ = newValue as NSSet
        }
    }
}

extension EntryAtributeSection {
    var attributes: Set<EntryAttribute> {
        get {
            return self.attributes_ as! Set<EntryAttribute>
        }
        
        set {
            self.attributes_ = newValue as NSSet
        }
    }
}

enum ValueType: String, CaseIterable, Identifiable {
    case String
    case Date
    case Boolean
    case Numeric
    
    var id: String {
        self.rawValue
    }
}

extension EntryAttribute {
    var type: ValueType {
        get {
            return ValueType(rawValue: self.type_ ?? ValueType.String.rawValue) ?? .String
        }
        
        set {
            self.type_ = newValue.rawValue
        }
    }
}


extension TopLevelEntry {
    static func fromTemplate(template: Template,  context: NSManagedObjectContext) -> TopLevelEntry {
        
        let newEntry = TopLevelEntry(context: context)
        //print(newEntry.sections)
        //print(template.sections)
        newEntry.sections = template.sections
        if(template.type != nil){
            newEntry.type = EntryType.fromTemplateType(templateType: template.type!, context: context)

        }
        return newEntry
    }
    
    var sections: Set<EntryAtributeSection> {
        get {
            var test = self.sections_
            if (self.sections_ == nil) {
                return Set<EntryAtributeSection>()
            }
            return self.sections_ as! Set<EntryAtributeSection>
        }
        
        set {
            self.sections_ = newValue as NSSet
        }
    }
}

extension EntryType {
    static func fromTemplateType(templateType: TemplateType, context: NSManagedObjectContext) -> EntryType {
        let entryType = EntryType(context: context)
        entryType.color = templateType.color
        entryType.icon = templateType.icon
        entryType.name = templateType.name
        entryType.isDefault = templateType.isDefault
        return entryType
    }
}





