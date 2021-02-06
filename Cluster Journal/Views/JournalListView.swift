//
//  JournalListView.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 06.02.21.
//

import SwiftUI

struct JournalListView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \LogbuchEntry.timestamp, ascending: true)], predicate: NSPredicate.all) var entries: FetchedResults<LogbuchEntry>
    var body: some View {
        ForEach(entries) { entry in
            LogbuchEntryView(entry: entry)
        }
    }
}

/*
struct JournalListView_Previews: PreviewProvider {
    static var previews: some View {
        JournalListView()
    }
}
 */
