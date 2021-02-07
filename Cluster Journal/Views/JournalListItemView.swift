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
                Text(entry.id?.uuidString ?? "No Id found")
            
            
            
            
        }
        
    }
}

/*
struct JournalListItemView_Previews: PreviewProvider {
    static var previews: some View {
        JournalListItemView()
    }
}*/
