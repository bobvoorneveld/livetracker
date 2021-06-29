//
//  SectionedListViewModel.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 28/06/2021.
//

import SwiftUI
import Combine

final class SectionedListViewModel: ObservableObject {
    
    @Published var rankedGroups = [RankedGroup]()
    @Published var showStarred = false {
        didSet {
            if !oldValue && showStarred {
                storedOpenSections = openSections
                openSections = Array<Bool>.init(repeating: true, count: 200)
            } else if oldValue && !showStarred {
                openSections = storedOpenSections
            }
        }
    }
    @Published var title = ""
    @Published var searchText = "" {
        didSet {
            if oldValue.isEmpty && !searchText.isEmpty {
                storedOpenSections = openSections
                openSections = Array<Bool>.init(repeating: true, count: 200)
            } else if !oldValue.isEmpty && searchText.isEmpty {
                openSections = storedOpenSections
            }
        }
    }
    @Published var openSections = Array<Bool>.init(repeating: false, count: 200)
    private var storedOpenSections = Array<Bool>.init(repeating: false, count: 200)

    // DI

    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        RiderStore.shared.$pelotonUpdates
            .compactMap { $0.first?.riders.first?.position }
            .map { "\($0.kmToFinish) km" }
            .assign(to: \.title, on: self)
            .store(in: &subscriptions)

        RiderStore.shared.$pelotonUpdates
            .assign(to: \.rankedGroups, on: self)
            .store(in: &subscriptions)
    }
    
    func include(rank: RankedRider) -> Bool {
        let search = searchText.lowercased()
        if searchText.isEmpty {
            if showStarred {
                return StarredBibs.shared.savedBibs.contains(rank.rider.bib!)
            }
            return true
        } else if let bib = Int(search), rank.rider.bib == bib {
            return true
        } else if rank.rider.name.lowercased().contains(search) {
            return true
        } else if rank.rider.team?.name.lowercased().contains(search) ?? false {
            return true
        }
        return false
    }

    func start() {
        print("starting")
        RiderStore.shared.startMonitoring()
    }
}
