//
//  TimeInterval.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 27/06/2021.
//

import Foundation

extension TimeInterval {
    private var seconds: Int {
        return Int(self) % 60
    }

    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }

    private var hours: Int {
        return Int(self) / 3600
    }

    var stringTime: String {
        if hours != 0 {
            return "\(hours):\(minutes):\(seconds)"
        } else if minutes != 0 {
            return "\(minutes):\(seconds)"
        } else {
            return "\(seconds)"
        }
    }
}
