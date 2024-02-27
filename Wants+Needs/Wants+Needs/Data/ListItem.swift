//
//  ListItem.swift
//  Wants&Needs
//
//  Created by Landon West on 12/21/23.
//
//  This class represents a Want or Need.
//  Each Want or Need must have a simple title.
//  They can also have additonal media, comments, or
//  even a price. The isWant Bool tells the app whether
//  it is a Want or Need.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class ListItem {
    // Saved Data
    var isWant: Bool
    var favorite: Bool
    var title: String
    // Optionals
    var price: Int?
    @Attribute(.externalStorage) var itemImage: Data? // It is better to save image data externally
    var itemURL: String?
    var info: String?
    
    // Initializing with just a title
    init(isWant: Bool, title: String) {
        self.isWant = isWant
        self.title = title
        self.favorite = false
    }
    
    // Initializing with any additional info
    init(isWant: Bool, favorite: Bool? = false, title: String, price: Int? = nil, itemImage: Data? = nil, itemURL: String? = nil, info: String? = nil) {
        self.isWant = isWant
        self.favorite = favorite ?? false
        self.title = title
        self.price = price
        self.itemImage = itemImage
        self.itemURL = itemURL
        self.info = info
    }
}
