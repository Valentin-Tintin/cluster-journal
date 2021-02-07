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
            return JournalEntryType(rawValue: self.typeDiscriminator_ ?? "") ?? .Default
        }
        
        set {
            self.typeDiscriminator_ = newValue.rawValue
        }
    }
    
}

