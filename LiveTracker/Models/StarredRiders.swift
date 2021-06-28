//
//  StarredRiders.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 27/06/2021.
//

import Foundation
import Combine
import SwiftUI


struct StarredBibs {
    
    static var shared = StarredBibs()
        
    @AppStorage("starredBibs") private(set) var savedBibs: [Int] = []

    private init() {
    }
    
    func add(bib: Int) {
        savedBibs.append(bib)
    }
    
    func remove(bib: Int) {
        savedBibs.removeAll { $0 == bib }
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
