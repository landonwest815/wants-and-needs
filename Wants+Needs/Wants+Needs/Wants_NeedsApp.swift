//
//  Wants_NeedsApp.swift
//  Wants+Needs
//
//  Created by Landon West on 12/19/23.
//

import SwiftUI
import SwiftData

@main
struct Wants_NeedsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [ListItem.self])
        }
    }
}
