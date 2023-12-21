//
//  NeedView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/20/23.
//

import SwiftUI

struct NeedView: View {
    let name: String

        var body: some View {
            Text("Selected need: \(name)")
                .font(.headline)
        }
}

#Preview {
    NeedView(name: "Some Text")
}
