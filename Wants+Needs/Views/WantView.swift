//
//  WantView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/19/23.
//

import SwiftUI

struct WantView: View {
    let name: String

        var body: some View {
            Text("Selected want: \(name)")
                .font(.headline)
        }
}

#Preview {
    WantView(name: "Some Text")
}
