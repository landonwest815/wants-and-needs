//
//  BoolExtension.swift
//  Wants&Needs
//
//  This class was retrieved from: https://www.hackingwithswift.com/forums/swiftui/how-can-i-sort-swiftdata-query-results-by-a-bool/24680
//
//  This helps us sort our Data Query based on favorited
//  items
//

import Foundation

extension Bool: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        // the only true inequality is false < true
        !lhs && rhs
    }
}
