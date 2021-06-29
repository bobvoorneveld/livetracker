//
//  RankViewModel.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 29/06/2021.
//

import SwiftUI
import Combine


final class RankViewModel: ObservableObject {
    @Published private(set) var overallRanking: [Ranking] = []
    
    @Published var showStarred = false
    @Published var searchText = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        RiderStore.shared.$overalRanking
            .assign(to: \.overallRanking, on: self)
            .store(in: &subscriptions)
    }
    
    func include(ranking: Ranking) -> Bool {
        let search = searchText.lowercased()
        if searchText.isEmpty {
            if showStarred {
                return StarredBibs.shared.savedBibs.contains(ranking.bib)
            }
            return true
        } else if let bib = Int(search), ranking.bib == bib {
            return true
        } else if let position = Int(search), ranking.position == position {
            return true
        } else if ranking.rider!.name.lowercased().contains(search) {
            return true
        } else if ranking.rider!.team?.name.lowercased().contains(search) ?? false {
            return true
        }
        return false
    }
}
