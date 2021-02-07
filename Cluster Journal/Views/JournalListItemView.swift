//
//  JournalListItemView.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 07.02.21.
//

import SwiftUI

struct JournalListItemView: View {
    @ObservedObject var entry : SuperJournalEntry;

    var body: some View {
        
        let destination : AnyView = entry.typeDiscriminator  == JournalEntryType.Default ? AnyView(LogbuchEntryView(superEntry: entry ))  : AnyView(PublicTransportJournalDetailView(superEntry: entry))
        NavigationLink(destination: destination) {
        HStack(alignment: VerticalAlignment.center, spacing: 20) {
            self.getIconByType()
            VStack(alignment: HorizontalAlignment.leading, spacing: 5 ) {
                   
                Text(entry.timestamp?.toString() ?? "").font(.caption).foregroundColor(.black)
                    Text(entry.id?.uuidString ?? "No Id found").font(.caption).foregroundColor(.black)
                    
                    }
                }
                
            }
    }
    
    
    private func getIconByType() -> AnyView {
        switch entry.typeDiscriminator {
        case .PublicTransport:
            return AnyView(Image(systemName: "bus").foregroundColor(.orange))
        default:
            return AnyView(Image(systemName: "person.3").foregroundColor(.red))
        }
    }
}

/*
struct JournalListItemView_Previews: PreviewProvider {
    static var previews: some View {
        JournalListItemView()
    }
}*/
