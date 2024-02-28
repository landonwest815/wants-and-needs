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

    // SwiftData
    @Environment(\.modelContext) var context
    @Query var userSettingsArray: [UserSettings]
                
    var body: some View {
                
        ZStack {
            ListsView()
                .blur(radius: userSettingsArray.first?.onboardUser ?? true ? 2.5 : 0)
            if userSettingsArray.first?.onboardUser ?? true {
                OnboardView()
            }
        }
        .onAppear() {
            handleUserSettings()
        }
    }
    
    private func handleUserSettings() {
        
        // Check if there is any data
        if let userSettings = userSettingsArray.first {
            userSettings.accentColor = userSettingsArray.first?.accentColor ?? "ff0000"
            
        // Create fresh user if not
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
