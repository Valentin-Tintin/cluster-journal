//
//  EntryDetailView.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 18.02.21.
//

import SwiftUI

struct EntryDetailView: View {
    @ObservedObject var entry: TopLevelEntry
    var body: some View {
        Text(entry.type?.name ?? "")
        Form(){
            Section(header: Text("Zeitpunkt")){
                Text(entry.timestamp.toString())
            }
            ForEach(Array(entry.sections)){section in
                Section(header: Text(section.name ?? "")){
                    ForEach(Array(section.attributes)) {
                        attr in
                        AttributeValueView(attribute: attr)
                    }
                }
                
            }
        }
    }
}

struct AttributeValueView: View {
    @State var attribute: EntryAttribute
    var body: some View {
        HStack {
            Text(attribute.name ?? "")
            getValueByType(attr: attribute)
        }
        
    }
    
    func getValueByType(attr: EntryAttribute) -> Text{
        switch attr.type {
        case .Boolean:
            return Text(attr.boolValue ? "True" : "False")
        case .Date:
            return Text(attr.dateValue?.toString() ?? "")
        case .Numeric:
            return Text(String(attr.numericValue))
        case .String:
            return Text(attr.stringValue ?? "")
        }
    }
}

