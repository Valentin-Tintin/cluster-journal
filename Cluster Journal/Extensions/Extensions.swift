//
//  Extensions.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 06.02.21.
//

import Foundation
import CoreData

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
}
