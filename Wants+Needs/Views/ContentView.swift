//
//  ContentView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/19/23.
//

import SwiftUI
import SwiftData

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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
       let container = try! ModelContainer(for: ListItem.self, configurations: config)

    return ContentView()
           .modelContainer(container)
}
