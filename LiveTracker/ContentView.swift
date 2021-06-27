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
            if let firstRider = viewModel.rankedGroups.first?.riders.first {
                Text(String(format: "Finish %.2fkm", firstRider.kmToFinish))
            }
            List {
                ForEach(viewModel.rankedGroups) { group in
                    Section {
                        DisclosureGroup {
                            ForEach(group.riders) { rank in
                                HStack {
                                    Text("\(rank.position)")
                                        .font(.footnote)
                                    Text(rank.rider.name)
                                    Text("\(rank.rider.bib!)")
                                        .font(.footnote)
                                }
                            }
                        } label: {
                            HStack(spacing: 2) {
                                Group {
                                    if group.riders.count == 1 {
                                        Image(systemName: "person")
                                    } else {
                                        Image(systemName: "person.2")
                                        Text("\(group.riders.count)")
                                            .font(.footnote)
                                    }
                                }.frame(width: 40)

                                Text("\(String(format: "%.1f", group.riders.first!.speed)) km/h")
                                    .font(.footnote)
                                    .padding(.leading, 10)

                                Spacer()

                                if group.riders.first!.secToFirstRider == 0 {
                                    Text("")
                                } else {
                                    Text("+\(group.riders.first!.secToFirstRider.stringTime)")
                                }
                            }
                        }
                    }
                }
            }
            HStack {
                Spacer()
                Text(viewModel.timeAgo)
                    .font(.footnote)
            }
            .padding()
        }
        .onAppear {
            viewModel.start()
        }
    }
    
    private func gapToLeaderInMeters(rider: RankedRider) -> Int {
        let leaderDistance = viewModel.rankedGroups.first?.riders.first?.kmToFinish ?? 0
        return Int((rider.kmToFinish - leaderDistance) * 1000.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
