//
//  LiveDataMiner.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 27/06/2021.
//

import Foundation
import Combine
import EventSource

struct TimestampedPeloton {
    let date: Date
    let riders: [PositionedRider]
}

final class LiveDataMiner {
    struct Config {
        static let liveStreamURL = URL(string: "https://racecenter.letour.fr/live-stream")!
    }
    
    private(set) var pelotonUpdates = PassthroughSubject<TimestampedPeloton, Never>()
    
    
    private let eventSource: EventSourceProtocol
    private var lastEventId: String?
    
    private var reconnect = true

    init(eventSource: EventSourceProtocol? = nil) {
        self.eventSource = eventSource ?? EventSource(url: Config.liveStreamURL)
        
        self.eventSource.addEventListener("update") { [weak self] in
            self?.onEvent(id: $0, event: $1, data: $2)
        }
        
        self.eventSource.onComplete { [weak self] in
            self?.onComplete(statusCode: $0, reconnect: $1, error: $2)
        }
    }
    
    func start() {
        reconnect = true
        eventSource.connect(lastEventId: lastEventId)
    }
    
    func stop() {
        reconnect = false
        lastEventId = nil
        eventSource.disconnect()
    }
    
    private func onEvent(id: String?, event: String?, data: String?) {
        lastEventId = id
        guard let data = data, data.contains("\"bind\":\"telemetryCompetitor-2021\"") else {
            return
        }
        
        guard let wrapper = try? JSONDecoder().decode(UpdateRidersDataWrapper.self, from: data.data(using: .utf8)!) else {
            return
        }
        
        // Get date out of update message?
        pelotonUpdates.send(TimestampedPeloton(date: Date(), riders: wrapper.data.Riders))
    }
    
    private func onComplete(statusCode: Int?, reconnect: Bool? = true, error: NSError?) {
        guard self.reconnect else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(eventSource.retryTime)) { [weak self] in
            self?.eventSource.connect(lastEventId: nil)
        }
    }
}
