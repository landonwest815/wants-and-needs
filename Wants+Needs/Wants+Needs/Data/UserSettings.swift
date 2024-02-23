//
//  UserSettings.swift
//  Wants+Needs
//
//  Created by Landon West on 12/21/23.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class UserSettings {
    var accentColor: String
    var appIcon: Int
    
    var selectedItem: ListItem?
    
    init() {
        accentColor = "ff0000"
        appIcon = 1
    }
}
