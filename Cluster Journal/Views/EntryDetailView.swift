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
        GeometryReader { reader in
                
            Form(){
                ZStack(alignment: Alignment.center){
                    Rectangle()
                        
                        .frame(height: reader.size.height/5)
                        .foregroundColor(Color.fromString(str: entry.type?.color ?? ""))
                    Image(systemName: entry.type?.icon ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32.0)
                        
                        .foregroundColor(Color.white)
                           
                        
                    
                }.listRowInsets(EdgeInsets())
                    
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
            .navigationBarTitle(Text(entry.type?.name ?? ""))
            
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

