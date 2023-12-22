//
//  ContentView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/19/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var context
    //@Query var userSettingsArray: [UserSettings]
    
    @State private var accentColor: Color = .blue
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
            .accentColor(accentColor)
        }
        .onAppear() {
            handleUserSettings()
        }
    }
    
    private func handleUserSettings() {
//        if let userSettings = userSettingsArray.first {
//            accentColor = userSettings.accentColor
//        } else {
//            let newUserSettings = UserSettings()
//            context.insert(newUserSettings)
//        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
       let container = try! ModelContainer(for: ListItem.self, configurations: config)

    return ContentView()
           .modelContainer(container)
}
