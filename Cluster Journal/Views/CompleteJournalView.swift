//
//  CompleteJournalView.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 19.02.21.
//

import SwiftUI

struct CompleteJournalView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TopLevelEntry.timestamp_, ascending: false)], predicate: NSPredicate.all) var entries: FetchedResults<TopLevelEntry>
    
    var body: some View {
        ZStack(alignment: Alignment.topLeading) {
            Form {
                
                ForEach(entries) {
                    entry in
                    EntryOverview(entry: entry)
                }
                
            }
        Spacer()
        }.navigationBarTitle(Text("Logbuch"))
        
    }
}

