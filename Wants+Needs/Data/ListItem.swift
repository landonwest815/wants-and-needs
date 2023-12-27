//
//  ListItem.swift
//  Wants+Needs
//
//  Created by Landon West on 12/21/23.
//
//  This class represents a Want or Need.
//  Each Want or Need must have a simple title.
//  They can also have additonal media or comments.
//  isWant Bool tells the program whether it is a want
//  or need.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class ListItem {
    // Data
    var isWant: Bool
    var title: String
    @Attribute(.externalStorage) var itemImage: Data?   // OPTIONAL
    var itemURL: String?
    var info: String?                                   // OPTIONAL
    
    // Just a title
    init(isWant: Bool, title: String) {
        self.isWant = isWant
        self.title = title
    }
    
    // Title + Media / Additional Info
    init(isWant: Bool, title: String, itemImage: Data? = nil, itemURL: String? = nil, info: String? = nil) {
        self.isWant = isWant
        self.title = title
        self.itemImage = itemImage
        self.itemURL = itemURL
        self.info = info
    }
}
