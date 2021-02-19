//
//  EntryOverview.swift
//  Cluster Journal
//
//  Created by Valentin Gilberg on 18.02.21.
//

import SwiftUI

struct EntryOverview: View {
    @ObservedObject var entry: TopLevelEntry
    
    var body: some View {
        NavigationLink(destination: EntryDetailView(entry: entry)){
            
        
            HStack(alignment: VerticalAlignment.center, spacing: 20) {
            Image(systemName: entry.type?.icon ?? "").foregroundColor(.orange)
            VStack(alignment: HorizontalAlignment.leading, spacing: 5 ) {
                   
                Text(entry.type?.name ?? "").font(.caption).foregroundColor(.black)
                Text(entry.timestamp.toString()).font(.caption).foregroundColor(.black)
                    
                    }
                }
                
        }
    }
       
       
    }



