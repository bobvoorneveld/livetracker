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
    private let liveDataMiner = LiveDataMiner()

    private var numberedRiders = [Int: FullRider]() {
        didSet {
            if oldValue.isEmpty && !numberedRiders.isEmpty {
                liveDataMiner.start()
            }
        }
    }

    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        // Map live data to riders
        liveDataMiner.pelotonUpdates
            .map { [unowned self] peloton in
                return peloton.groups.enumerated().map { index, group in
                    let riders = group.riders.compactMap { rider -> RankedRider? in
                        guard let fullRider = self.numberedRiders[rider.Bib] else {
                            return nil
                        }
                        return RankedRider(
                            id: rider.Bib,
                            rider: fullRider,
                            position: rider
                        )
                    }
                    
                    return RankedGroup(id: index,
                                       riders: riders,
                                       size: group.riders.count,
                                       speed: group.riders.first!.kph,
                                       secToFirstRider: group.riders.first!.secToFirstRider
                                       )
                }
            }
            .assign(to: \.rankedGroups, on: self)
            .store(in: &subscriptions)
        
        
        liveDataMiner.pelotonUpdates
            .compactMap { $0.groups.first?.riders.first }
            .map { "Finish \($0.kmToFinish) km" }
            .assign(to: \.title, on: self)
            .store(in: &subscriptions)
    }

    struct Config {
        static let ridersDataURL = URL(string: "https://racecenter.letour.fr/api/allCompetitors-2021")!
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
    
    private func loadRiders() {
        print("loading riders")
        URLSession.shared.dataTaskPublisher(for: Config.ridersDataURL)
            .map(\.data)
            .decode(type: [FullRider].self, decoder: JSONDecoder.iso8601)
            .replaceError(with: [])
            .map { $0.filter { $0.bib != nil } }
            .map { riders in
                return riders.reduce(into: [Int: FullRider]()) { dict, rider in
                    dict[rider.bib ?? -1] = rider
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.numberedRiders, on: self)
            .store(in: &subscriptions)
    }

    func start() {
        print("starting")
        loadRiders()
    }
}
