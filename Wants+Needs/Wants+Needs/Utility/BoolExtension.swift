//
//  BoolExtension.swift
//  Wants+Needs
//
//  Created by Landon West on 2/23/24.
//
//  This class was retrieved from:
//
//  https://www.hackingwithswift.com/forums/swiftui/how-can-i-sort-swiftdata-query-results-by-a-bool/24680

import Foundation

extension Bool: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        // the only true inequality is false < true
        !lhs && rhs
    }
}
