//
//  RankView.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 29/06/2021.
//

import SwiftUI


struct RankView: View {
    
    @ObservedObject private var viewModel = RankViewModel()

    var body: some View {
        VStack {
            HStack {
                Text("Overall ranking")
                Spacer()
                Toggle(isOn: $viewModel.showStarred) { }
                Image(systemName: viewModel.showStarred ? "star.fill" : "star" )
                    .foregroundColor(viewModel.showStarred ? .yellow: .gray)
            }
            .padding()

            SearchBar(text: $viewModel.searchText)

            List {
                ForEach(viewModel.overallRanking) { rank in
                    if viewModel.include(ranking: rank) {
                        HStack {
                            Text("\(rank.position)")
                            Text("\(rank.bib)")
                                .font(.footnote)
                            Text(rank.rider!.name)
                            Spacer()
                            if rank.relative == 0 {
                                Text("+\(rank.absolute.stringTime)")
                            } else {
                                Text("+\(rank.relative.stringTime)")
                            }
                        }
                    }
                }
            }.animation(.default)
        }
    }
}
