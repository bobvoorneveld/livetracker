//
//  FullRider.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 26/06/2021.
//

import Foundation


struct FullRider: Decodable, Identifiable {
    
    let id: String
    let lastname: String?
    let birthdate: Date?
    let firstname: String?
    let lastnameshort: String?
    let bib: Int?
        
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case lastname
        case birthdate
        case firstname
        case lastnameshort
        case bib
    }
    
    var name: String {
        "\(firstname!) \(lastnameshort!.localizedCapitalized)"
    }
}
