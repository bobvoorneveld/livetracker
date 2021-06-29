//
//  RiderStore.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 28/06/2021.
//

import Foundation
import Combine


final class RiderStore: ObservableObject {
    
    static let shared = RiderStore()

    @Published var pelotonUpdates = [RankedGroup]()

    private var numberedRiders = [Int: FullRider]()
    private var subscriptions = Set<AnyCancellable>()

    // DI
    private let liveDataMiner = LiveDataMiner()

    private struct Config {
        static let ridersDataURL = URL(string: "https://racecenter.letour.fr/api/allCompetitors-2021")!
    }

    private init() {}

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
    
    func startMonitoring() {
        loadRiders()
        liveDataMiner.start()
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
            .assign(to: \.pelotonUpdates, on: self)
            .store(in: &subscriptions)
                
    }
}
