//
//  ContentViewViewModel.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 26/06/2021.
//

import Foundation
import Combine
import EventSource

final class ContentViewViewModel: ObservableObject {
    
    var eventSource: EventSource!
    
    @Published var riders = [Int: FullRider]() {
        didSet {
            if oldValue.isEmpty && !riders.isEmpty {
                eventSource.connect()
            }
        }
    }
    @Published var rankedRiders = [RankedRider]()
    @Published var lastUpdate: Date? {
        didSet {
            timeAgo = "Nu"
        }
    }
    @Published var timeAgo = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let timer = Timer.publish(
        every: 1, // second
            on: .main,
            in: .common
        ).autoconnect()


    struct Config {
        static let liveStreamURL = URL(string: "https://racecenter.letour.fr/live-stream")!
        static let ridersDataURL = URL(string: "https://racecenter.letour.fr/api/allCompetitors-2021")!
    }
    
    private func loadRiders() {
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
            .assign(to: \.riders, on: self)
            .store(in: &subscriptions)
        
        timer.map { _ in
            guard let lastUpdate = self.lastUpdate else { return self.timeAgo }
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full

            return formatter.localizedString(for: lastUpdate, relativeTo: Date())
        }.assign(to: \.timeAgo, on: self)
        .store(in: &subscriptions)
    }

    func start() {
        print("starting")
        loadRiders()
        eventSource = EventSource(url: Config.liveStreamURL)
        eventSource.onOpen {
            print("open")
        }
        
        eventSource.addEventListener("update") { id, event, data in
            guard let data = data, data.contains("\"bind\":\"telemetryCompetitor-2021\"") else {
                return
            }
            
            guard let wrapper = try? JSONDecoder().decode(UpdateRidersDataWrapper.self, from: data.data(using: .utf8)!) else {
                return
            }
            
            let updatedRiders = wrapper.data.Riders
            
            var rankedRiders: [RankedRider] = updatedRiders.compactMap { rider in
                guard let fullRider = self.riders[rider.Bib] else {
                    return nil
                }
                let rankedRider = RankedRider(id: rider.Bib, rider: fullRider, position: rider.Pos, secToFirstRider: rider.secToFirstRider)
                return rankedRider
            }
            
            rankedRiders.sort { $0.position < $1.position }
            self.rankedRiders = rankedRiders
            self.lastUpdate = Date()
        }
        
        eventSource.onComplete { [weak self] statusCode, reconnect, error in

            let retryTime = self?.eventSource?.retryTime ?? 3000
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(retryTime)) { [weak self] in
                print("reconnect")
                self?.eventSource?.connect()
            }
        }
    }
}

struct RankedRider: Identifiable {
    let id: Int
    let rider: FullRider

    var position: Int = -1
    var secToFirstRider: TimeInterval = 0
}

let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
}()
