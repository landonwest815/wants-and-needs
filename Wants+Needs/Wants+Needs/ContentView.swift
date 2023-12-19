//
//  ContentView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/19/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ZStack {
            TabView {
                WantsView()
                    .tabItem() {
                        Image(systemName: "heart")
                        Text("Wants")
                    }
                NeedsView()
                    .tabItem() {
                        Image(systemName: "brain")
                        Text("Needs")
                    } 
            }
        }
        
    }
}

#Preview {
    ContentView()
}
