//
//  Searchbar.swift
//  LiveTracker
//
//  Created by Bob Voorneveld on 28/06/2021.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
 
    @State private var isEditing = false {
        didSet {
            if !isEditing {
                withAnimation {
                    UIApplication.shared.endEditing()
                }
            }
        }
    }

    var body: some View {
        HStack {
 
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
 
            if isEditing {
                Button(action: {
                    self.text = ""
                    withAnimation {
                        self.isEditing = false
                    }
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

//struct Searchbar_Previews: PreviewProvider {
//    @State var searchText: String = ""
//    static var previews: some View {
//        SearchBar(text: $searchText)
//    }
//}
