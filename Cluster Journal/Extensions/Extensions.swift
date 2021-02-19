//
//  Extensions.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 06.02.21.
//

import Foundation
import CoreData
import SwiftUI

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
}

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}

extension Color {
    public static func fromString(str: String) -> Color{
        let str_lower = str.lowercased()
        switch str_lower {
        case "orange":
            return Color.orange
        case "blue":
            return Color.blue
        case "green":
            return Color.green
        case "red":
            return Color.red
        case "yellow":
            return Color.yellow
        case "purple":
            return Color.purple
        default:
            return Color.orange
        }
    }
}
