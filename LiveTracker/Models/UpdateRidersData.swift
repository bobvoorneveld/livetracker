//
//  UpdateRidersData.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 26/06/2021.
//

import Foundation


struct UpdateRidersDataWrapper: Decodable {
    let data: UpdateRidersData
}


struct UpdateRidersData: Decodable {
    let Riders: [PositionedRider]
}

struct PositionedRider: Decodable {
    let secToFirstRider: TimeInterval
    let Pos: Int
    let Gradient: Int
    let kph: Double
    let kphAvg: Double
    let kmToFinish: Double
    let Course: Double
    let Latitude: Double
    let Longitude: Double
    let Bib: Int
}
