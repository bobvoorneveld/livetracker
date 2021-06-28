//
//  SectionedListView.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 28/06/2021.
//

import SwiftUI

struct SectionedListView: View {
    
    @ObservedObject var viewModel = SectionedListViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "flag.fill")
                Text(viewModel.title)
                Spacer()
                Toggle(isOn: $viewModel.showStarred) { }
                Image(systemName: viewModel.showStarred ? "star.fill" : "star" )
                    .foregroundColor(viewModel.showStarred ? .yellow: .gray)
            }
            .padding()

            SearchBar(text: $viewModel.searchText)
            
            List {
                ForEach(viewModel.rankedGroups) { group in
                    Section {
                        DisclosureGroup(isExpanded: $viewModel.openSections[group.id]) {
                            ForEach(group.riders) { rank in
                                if viewModel.include(rank: rank) {
                                    RiderCell(rank: rank)
                                }
                            }
                        } label: {
                            HStack(spacing: 2) {
                                Group {
                                    if group.size == 1 {
                                        Image(systemName: "person")
                                    } else {
                                        Image(systemName: "person.2")
                                        Text("\(group.size)")
                                            .font(.footnote)
                                    }
                                }.frame(width: 40)

                                Text("\(String(format: "%.1f", group.speed)) km/h")
                                    .font(.footnote)
                                    .padding(.leading, 10)

                                Spacer()

                                if group.secToFirstRider == 0 {
                                    Text("")
                                } else {
                                    Text("+\(group.secToFirstRider.stringTime)")
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.start()
        }
    }
}
