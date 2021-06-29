//
//  MainTabView.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 28/06/2021.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            SectionedListView()
                .tabItem {
                    Label("Peloton", systemImage: "bicycle.circle")
                }
            RankView()
                .tabItem {
                    Label("Ranking", systemImage: "person.3")
                }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
