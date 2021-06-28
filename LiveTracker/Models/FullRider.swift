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
    let teamID: String?
    var team: Team? {
        get {
            guard let id = teamID else { return nil }
            return Team.teams.first { id.contains($0.id)}
        }
    }
        
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case lastname
        case birthdate
        case firstname
        case lastnameshort
        case bib
        case teamID = "$team"
    }
    
    var name: String {
        "\(firstname!) \(lastnameshort!.localizedCapitalized)"
    }
}
