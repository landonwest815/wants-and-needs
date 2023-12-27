//
//  ContentView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/19/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Query var userSettingsArray: [UserSettings]
            
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
            .accentColor(Color(hex: userSettingsArray.first?.accentColor ?? "ff0000"))
        }
        .onAppear() {
            handleUserSettings()
        }
    }
    
    private func handleUserSettings() {
        if let userSettings = userSettingsArray.first {
            userSettings.accentColor = userSettingsArray.first?.accentColor ?? "ff0000"
        } else {
            let newUserSettings = UserSettings()
            context.insert(newUserSettings)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserSettings.self, ListItem.self, configurations: config)
    let userSettings =  UserSettings()
    container.mainContext.insert(userSettings)

    return ContentView()
           .modelContainer(container)
}
