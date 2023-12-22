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
    
    @Query var userSettingsArray: [UserSettings]
    @State private var accentColor: Color = .purple

    private let alternateAppIcons: [String] = [
    "AppIconPink",
    "AppIconPink",
    "AppIconPink"
    ]

    // UI
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                // MARK: - Title
                Section {
                    LabeledContent {
                        
                    } label: {
                        HStack {
                            Text("Accent Color")
                            Spacer()
                            
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(accentColor)
                                    .background(
                                                NavigationLink("", destination: ColorPickerView(selectedColor: $accentColor))
                                                    .opacity(0)
                                                )
                            
                        }
                    }
                }
                header: {
                    Text("Customization")
                }
                
                Section {
                    HStack {
                        Spacer()
                        ForEach(alternateAppIcons.indices, id: \.self) { item in
                            Button {
                                print("Icon was pressed.")
                                UIApplication.shared
                                    .setAlternateIconName(alternateAppIcons[item])
                                { error in
                                    if error != nil {
                                        print("Failed")
                                    } else {
                                        print("Success")
                                    }
                                }
                                
                            } label: {
                                Image("\(alternateAppIcons[item])Image")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(14)
                            }
                            .buttonStyle(.borderless)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.vertical, -10)
                .listRowBackground(Color(UIColor.systemGroupedBackground))            }
            
            
                                        
            }
            .navigationBarTitle("Settings")
            .onAppear() {
                pullFromUserSettings()
            }
            .onChange(of: accentColor) {
                    updateAccentColorInUserSettings()
                }
        }
    
    private func updateAccentColorInUserSettings() {
        if let userSettings = userSettingsArray.first {
            userSettings.accentColor = accentColor.toHex() ?? "FFFFFF"
        }
    }
    
    private func pullFromUserSettings() {
        if let userSettings = userSettingsArray.first {
            accentColor = Color(hex: userSettings.accentColor) ?? .red
                }
    }
        
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
       let container = try! ModelContainer(for: ListItem.self, UserSettings.self, configurations: config)
    let userSettings =  UserSettings()
    userSettings.accentColor = "FFFFFF"
    container.mainContext.insert(userSettings)

    return SettingsView()
           .modelContainer(container)
}
