//
//  NeedsView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/19/23.
//

import SwiftUI

struct NeedsView: View {
    
    @State private var needs = ["Basketball", "Curry 11 'Jackie Chan'", "Cargo Pants"]

        var body: some View {
            NavigationStack {
                List {
                    ForEach(needs, id: \.self) { need in
                        //Text(want)
                        NavigationLink(need) {
                            NeedView(name: need)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .navigationTitle("Needs")
                .toolbar {
                    // Add
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        // MARK: - Add Want
                            Button {
                                //isShowingSheet.toggle()
                            } label: {
                                Image(systemName: "plus.circle")
                            }
//                            .sheet(isPresented: $isShowingSheet) {
//                                AddWantView()
//                                    .presentationDragIndicator(.visible)
//                                    .presentationDetents([.large])
//                            }
                        }
                    // Cancel
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                            Button {
                                
                            } label: {
                                Image(systemName: "gear")
                            }
                        }
                }
            }
        }

        func delete(at offsets: IndexSet) {
            needs.remove(atOffsets: offsets)
        }
    
}

#Preview {
    NeedsView()
}
