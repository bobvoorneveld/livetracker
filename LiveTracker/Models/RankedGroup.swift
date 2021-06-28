//
//  RankedGroup.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 28/06/2021.
//

import Foundation

struct RankedGroup: Identifiable {
    let id: Int
    let riders: [RankedRider]
    let size: Int
    let speed: Double
    let secToFirstRider: TimeInterval
}
