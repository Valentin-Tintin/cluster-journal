//
//  LogbuchEntry.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 17.12.20.
//

import SwiftUI
import CoreData

struct LogbuchEntryView: View {
    @ObservedObject var entry : LogbuchEntry;

   	 var body: some View {
        Text(entry.notes ?? "default value")
    }
}

/*struct LogbuchEntry_Previews: PreviewProvider {
    static var previews: some View {
        //LogbuchEntryView(entry: LogbuchEntry)
    }
}
 */
