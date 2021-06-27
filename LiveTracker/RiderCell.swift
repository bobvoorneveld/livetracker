//
//  RiderCell.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 27/06/2021.
//

import SwiftUI

struct RiderCell: View {
    let rank: RankedRider

    var body: some View {
        HStack {
            Text("\(rank.position.Pos)")
                .font(.footnote)
            if let team = rank.rider.team {
                URLImageView(url: team.jerseyURL)
                    .frame(width: 20, height: 20)
            }
            Text("\(rank.rider.bib!)")
                .font(.footnote)
                .frame(width: 25, alignment: .trailing)
            Text(rank.rider.name)
        }
    }
}
