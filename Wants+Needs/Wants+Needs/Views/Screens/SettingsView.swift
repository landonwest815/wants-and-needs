//
//  SettingsView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/21/23.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    
    // Allows this view to be dismissed
    @Environment(\.dismiss) var dismiss
    
    // Pull Data
    @Environment(\.modelContext) var context
    @Query var userSettingsArray: [UserSettings]
    
    // These are updated during onAppear()
    @State private var accentColor: Color = .purple
    @State private var appIcon: Int = 1
    
    // Prompts upon Data Reset
    @State private var showConfirmation = false

    // Determines the start of the file name
    private let alternateAppIcons: [String] = [
    "AppIcon1",
    "AppIcon2"
    ]

    // UI
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                // MARK: - Accent Color Selection
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
                
                // MARK: - App Icon Selection
                Section {
                    HStack {
                        Spacer()
                        ForEach(alternateAppIcons.indices, id: \.self) { item in
                            Button {
                                setApplicationIconName(iconName: alternateAppIcons[item] + (accentColor.toHex() ?? "ff0000"))
                                appIcon = item + 1
                                if let userSettings = userSettingsArray.first {
                                    userSettings.appIcon = appIcon
                                    }
                                
                            } label: {
                                Image("\(alternateAppIcons[item] + (accentColor.toHex() ?? "ff0000"))Image")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white, lineWidth: appIcon == item + 1 ? 3 : 0)
                                    )
                                
                            }
                            .buttonStyle(.borderless)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.vertical, -10)
                .listRowBackground(Color(UIColor.systemGroupedBackground))
                
                // MARK: - Reset Data
                Section {
                    Button {
                        showConfirmation = true
                    } label: {
                        Text("Reset Data")
                            .foregroundColor(.red)
                    }
                    .confirmationDialog("Delete data?", isPresented: $showConfirmation) {
                        Button("Delete everything!", role: .destructive, action: {
                                do {
                                    try context.delete(model: ListItem.self)
                                    try context.delete(model: UserSettings.self)
                                    let newUserSettings = UserSettings()
                                    context.insert(newUserSettings)
                                    pullFromUserSettings()
                                } catch {
                                    print("Failed to clear all data.")
                                }
                        })
                        
                        // This button overrides the default Cancel button.
                        Button("Mmm.. nevermind", role: .cancel, action: {})
                    }
                    message: {
                        Text("Careful! This action is permanent and cannot be undone.")
                    }
                }
                header: {
                    Text("Data")
                }
                
                // MARK: - Developer Info
                Section {
                    HStack {

                        Text("Version")
                            .foregroundColor(.white)

                        Spacer()
                        
                        Text("1.0")
                            .foregroundColor(.white)

                    }
                    HStack {

                        Text("Developer")
                            .foregroundColor(.white)

                        Spacer()
                        
                        Text("Landon West")
                            .foregroundColor(.white)

                    }
                }
                header: {
                    Text("Developer Info")
                }
            }
        }
        .navigationBarTitle("Settings")
        .onAppear() {
            pullFromUserSettings()
        }
        .onChange(of: accentColor) {
            updateAccentColorInUserSettings()
        }
    }
    
    /* This private helper method updates the selected color in Data so it can relay throughout the app. */
    private func updateAccentColorInUserSettings() {
        if let userSettings = userSettingsArray.first {
            userSettings.accentColor = accentColor.toHex() ?? "ff0000"
            setApplicationIconName(iconName: "AppIcon\(userSettings.appIcon)\(userSettings.accentColor)")
        }
    }
    
    /* This allows the SettingsView to be up to date Accent Color wise and App Icon wise*/
    private func pullFromUserSettings() {
        if let userSettings = userSettingsArray.first {
            accentColor = Color(hex: userSettings.accentColor) ?? .red
            appIcon = userSettings.appIcon
        }
    }
    
    /* This private helper method allows for App Icon changing in a traditional XCode Project. This lost its functionality within the Playground Package but I wanted to leave it in here. */
    private func setApplicationIconName(iconName: String) {
        if UIApplication.shared.responds(to: #selector(getter: UIApplication.supportsAlternateIcons)) && UIApplication.shared.supportsAlternateIcons {
            
            typealias setAlternateIconName = @convention(c) (NSObject, Selector, NSString, @escaping (NSError) -> ()) -> ()
            
            let selectorString = "_setAlternateIconName:completionHandler:"
            
            let selector = NSSelectorFromString(selectorString)
            let imp = UIApplication.shared.method(for: selector)
            let method = unsafeBitCast(imp, to: setAlternateIconName.self)
            method(UIApplication.shared, selector, iconName as NSString, { _ in })
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
   
    let container = try! ModelContainer(for: ListItem.self, UserSettings.self, configurations: config)
    
    let userSettings =  UserSettings()
    userSettings.accentColor = "ff0000"
    
    container.mainContext.insert(userSettings)

    return SettingsView()
           .modelContainer(container)
}
