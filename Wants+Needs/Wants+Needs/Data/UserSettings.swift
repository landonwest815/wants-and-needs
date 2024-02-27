//
//  UserSettings.swift
//  Wants&Needs
//
//  This class represents the User Data. Users can
//  set the Accent Color, which will relay throughout
//  the apps many elements, and set the App Icon (This
//  works in a traditional SwiftUI app, but not in this
//  Playground instance).
//

import Foundation
import SwiftUI
import SwiftData

@Model
class UserSettings {
    var accentColor: String // This is saved in a string due to it being a much better data type to store in SwiftData
    var appIcon: Int // This is only ever set to a 1 or 2. This allows us to easily set a variation of AppIcon based on the file naming I structured.
    
    init() {
        // Default to these settings upon instantiation
        accentColor = "ff0000"
        appIcon = 1
    }
}
