//
//  WantsView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/19/23.
//
//  This class represents the View for Wants.
//  Wants can be added and deleted from here
//  and will update in real time. Adding wants
//  will call the AddWantView view.
//

import SwiftUI
import SwiftData

struct WantsView: View {
    
    // Swift Data
    @Environment(\.modelContext) var context
    @Query var wants: [Want]
    
    // Class Data
    @State private var isShowingSheet: Bool = false

    // UI
    var body: some View {
        
        NavigationStack {
            
            // MARK: - List of Wants
                List {
                    ForEach(wants, id: \.self) { want in
                        // If a want is tapped, bring up its information using WantView
                        NavigationLink(want.want) {
                            WantView(want: want)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .navigationTitle("Wants")
                .toolbar {
                    
                    
                }
                .toolbar {
                    // Add
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        // MARK: - Add Want
                            Button {
                                isShowingSheet.toggle()
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                            .sheet(isPresented: $isShowingSheet) {
                                AddWantView()
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.large])
                            }
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

    // MARK: - Delete Want
    func delete(_ indexSet: IndexSet) {
        for i in indexSet {
            let want = wants[i]
            context.delete(want)
        }
    }
}

#Preview {
    WantsView()
}
