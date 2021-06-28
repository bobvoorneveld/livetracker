//
//  JSONDecoder.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 28/06/2021.
//

import Foundation

extension JSONDecoder {
    static var iso8601: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
