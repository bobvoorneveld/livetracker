//
//  ContentView.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 26/06/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject private var viewModel = ContentViewViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.timeAgo)
            List(viewModel.rankedRiders) { rank in
                HStack {
                    Text("\(rank.position)")
                    Text("\(rank.rider.bib!)")
                    Text(rank.rider.name)
                    Spacer()
                    Text("\(Int(rank.secToFirstRider))")
                }
            }
        }
        .onAppear {
            viewModel.start()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
