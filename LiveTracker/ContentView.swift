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
                Text(String(format: "Finish %.2fkm", firstRider.position.kmToFinish))
            }
            List {
                ForEach(viewModel.rankedGroups) { group in
                    Section {
                        DisclosureGroup {
                            ForEach(group.riders) { rank in
                                if StarredBibs.shared.savedBibs.contains(rank.rider.bib!) || !viewModel.showStarred {
                                    RiderCell(rank: rank)
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

                                Text("\(String(format: "%.1f", group.riders.first!.position.kph)) km/h")
                                    .font(.footnote)
                                    .padding(.leading, 10)

                                Spacer()

                                if group.riders.first!.position.secToFirstRider == 0 {
                                    Text("")
                                } else {
                                    Text("+\(group.riders.first!.position.secToFirstRider.stringTime)")
                                }
                            }
                        }
                    }
                }
            }
            HStack {
                Toggle(isOn: $viewModel.showStarred) {
                    Image(systemName:"star.fill")
                        .foregroundColor(.yellow)
                }
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
        let leaderDistance = viewModel.rankedGroups.first?.riders.first?.position.kmToFinish ?? 0
        return Int((rider.position.kmToFinish - leaderDistance) * 1000.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
