//
//  SettingsView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/21/23.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    
    // SwiftData
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    // UI
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                // MARK: - Title
                    Section {
                        
                    }
                    header: {
                        Text("Customization")
                    }
                
                // MARK: - Media
                    Section {
                       
                    }
                    header: {
                        Text("Stuff")
                    }
                    
                // MARK: - Additional
                    Section {
                        
                    }
                    header: {
                        Text("Additional")
                    }
                
            } //: Form
            .navigationBarTitle("Settings")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
       let container = try! ModelContainer(for: ListItem.self, configurations: config)

    return SettingsView()
           .modelContainer(container)
}
