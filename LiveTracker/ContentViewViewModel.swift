//
//  ContentViewViewModel.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 26/06/2021.
//

import Foundation
import Combine

final class ContentViewViewModel: ObservableObject {
    
    @Published var rankedGroups = [RankedGroup]()
    @Published var timeAgo = ""

    // DI
    private let liveDataMiner = LiveDataMiner()

    private var numberedRiders = [Int: FullRider]() {
        didSet {
            if oldValue.isEmpty && !numberedRiders.isEmpty {
                liveDataMiner.start()
            }
        }
    }
    private var lastUpdate: Date? {
        didSet {
            timeAgo = "Nu"
        }
    }

    private var subscriptions = Set<AnyCancellable>()
    
    private let timer = Timer.publish(
        every: 1, // second
            on: .main,
            in: .common
        ).autoconnect()

    
    init() {
        // Map live data to riders
        liveDataMiner.pelotonUpdates
            .map { peloton in
                return peloton.groups.enumerated().map { index, group in
                    let riders = group.riders.compactMap { rider -> RankedRider? in
                        guard let fullRider = self.numberedRiders[rider.Bib] else {
                            return nil
                        }
                        return RankedRider(
                            id: rider.Bib,
                            rider: fullRider,
                            position: rider.Pos,
                            secToFirstRider: rider.secToFirstRider,
                            speed: rider.kphAvg,
                            kmToFinish: rider.kmToFinish
                        )
                    }
                    
                    return RankedGroup(id: index, riders: riders)
                }
            }
            .assign(to: \.rankedGroups, on: self)
            .store(in: &subscriptions)
        
        // Store last update time
        liveDataMiner.pelotonUpdates
            .compactMap { $0.date }
            .assign(to: \.lastUpdate, on: self)
            .store(in: &subscriptions)
        
        // Update lastUpdate time every second
        timer.map { [unowned self] _ in
            guard let lastUpdate = self.lastUpdate else { return "Offline" }
                return Date().timeIntervalSince(lastUpdate).stringTime
        }.assign(to: \.timeAgo, on: self)
        .store(in: &subscriptions)
    }

    struct Config {
        static let liveStreamURL = URL(string: "https://racecenter.letour.fr/live-stream")!
        static let ridersDataURL = URL(string: "https://racecenter.letour.fr/api/allCompetitors-2021")!
    }
    
    private func loadRiders() {
        print("loading riders")
        URLSession.shared.dataTaskPublisher(for: Config.ridersDataURL)
            .map(\.data)
            .decode(type: [FullRider].self, decoder: decoder)
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

struct RankedGroup: Identifiable {
    let id: Int
    let riders: [RankedRider]
}

struct RankedRider: Identifiable {
    let id: Int
    let rider: FullRider

    var position: Int = -1
    var secToFirstRider: TimeInterval = 0
    var speed = 0.0
    var kmToFinish = 0.0
}

let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
}()
