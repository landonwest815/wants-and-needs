//
//  WantsView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/19/23.
//

import SwiftUI

struct WantsView: View {
    
    @State private var wants = ["Playstation 5", "Wilson Evo Basketball", "Raising Cane's"]

        var body: some View {
            NavigationStack {
                List {
                    ForEach(wants, id: \.self) { want in
                        //Text(want)
                        NavigationLink(want) {
                            WantView(name: want)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .navigationTitle("Wants")
            }
        }

        func delete(at offsets: IndexSet) {
            wants.remove(atOffsets: offsets)
        }
    
}

#Preview {
    WantsView()
}
