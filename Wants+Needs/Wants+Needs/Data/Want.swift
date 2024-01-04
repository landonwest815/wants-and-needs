//
//  Want.swift
//  Wants+Needs
//
//  Created by Landon West on 12/20/23.
//
//  This is a class that represents a 'want' object.
//  A want must contain a simple text of what it is.
//  Wants can also have media and additonal info for
//  deeper details.
//
//  Example:
//      Want - New Basketball
//      Media - Link to OR Image of the basketball
//      Additional Info - 'Nike Championship Elite Basketball - $75'
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Want {
    // Data
    var want: String
    @Attribute(.externalStorage) var wantImage: Data?   // OPTIONAL
    var info: String?                                   // OPTIONAL
    
    // Just a want
    init(want: String) {
        self.want = want
    }
    
    // Want + Media / Additional Info
    init(want: String, wantImage: Data? = nil, info: String? = nil) {
           self.want = want
           self.wantImage = wantImage
           self.info = info
    }
}
