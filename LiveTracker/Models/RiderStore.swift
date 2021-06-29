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
    @Published var overalRanking = [Ranking]()

    private var numberedRiders = [Int: FullRider]()
    private var subscriptions = Set<AnyCancellable>()

    // DI
    private let liveDataMiner = LiveDataMiner()

    private struct Config {
        static let ridersDataURL = URL(string: "https://racecenter.letour.fr/api/allCompetitors-2021")!
        static let stageInfo = "https://racecenter.letour.fr/api/rankingType-2021-"
    }

    private init() {}

    private func loadRiders() {
        print("loading riders")
        let getRidersInfo = URLSession.shared.dataTaskPublisher(for: Config.ridersDataURL)
            .map(\.data)
            .decode(type: [FullRider].self, decoder: JSONDecoder.iso8601)
            .replaceError(with: [])
            .map { $0.filter { $0.bib != nil } }
            .map { riders in
                return riders.reduce(into: [Int: FullRider]()) { dict, rider in
                    dict[rider.bib ?? -1] = rider
                }
            }
            .share()
            .eraseToAnyPublisher()
            
        getRidersInfo
            .receive(on: DispatchQueue.main)
            .assign(to: \.numberedRiders, on: self)
            .store(in: &subscriptions)
        
        getRidersInfo.combineLatest(loadRankings())
            .map { riderDict, rankings in
                rankings.map { rank -> Ranking in
                    var rank = rank
                    rank.rider = riderDict[rank.bib]!
                    return rank
                }
            }
            .assign(to: \.overalRanking, on: self)
            .store(in: &subscriptions)
    }
    private func loadRankingDataFromOnline() -> AnyPublisher<[[String: Any]], Never> {
        // Hacky. Get number of days since the start of the tour. Is there a better way?
        let startOfTour = Date(timeIntervalSince1970: 1624582800)
        let day = Calendar.current.dateComponents([.day], from: startOfTour, to: Date()).day!
        let stageURL = URL(string: Config.stageInfo + "\(day - 1)")!
        
        return URLSession.shared.dataTaskPublisher(for: stageURL)
            .map(\.data)
            .tryCompactMap { try JSONSerialization.jsonObject(with: $0, options: []) as? [Dictionary<String, Any>] }
            .map { $0.filter { $0["_bind"] as? String ?? "" == "rankingType-2021-3" }}
            .replaceError(with: [])
            .share()
            .eraseToAnyPublisher()
    }

    private func loadRankings() -> AnyPublisher<[Ranking], Never> {
        loadRankingDataFromOnline()
            // ipe => stage ranking
            // ijg => youth ranking overall
            // img => mountain ranking overall
            // ice => red bib
            // ime => polkadot jersey
            // itg => yellow ranking overall
            .compactMap { $0.first { $0["type"] as! String == "itg" } }
            .map { $0["rankings"] as? [[String: Any]] ?? [] }
            .map { rankingData -> [Ranking] in
                var rankings = [Ranking]()
                for rider in rankingData {
                    rankings.append(
                        Ranking(
                            bib: rider["bib"] as! Int,
                            absolute: TimeInterval(rider["absolute"] as! Int) / 1000,
                            relative: TimeInterval(rider["relative"] as! Int) / 1000,
                            penality: rider["penality"] as! Int,
                            position: rider["position"] as! Int,
                            bonus: rider["bonus"] as! Int
                        )
                    )
                }
                return rankings
            }.eraseToAnyPublisher()
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


struct Ranking: Identifiable {
    var id: Int {
        get {
            bib
        }
    }
    let bib: Int
    let absolute: TimeInterval
    let relative: TimeInterval
    let penality: Int
    let position: Int
    let bonus: Int
    var rider: FullRider?
}
