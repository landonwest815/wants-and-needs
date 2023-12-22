//
//  WantsView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/19/23.
//
//  This class represents the View for Wants.
//  Wants can be added and deleted from here
//  and will update in real time. Adding wants
//  will call the AddListItemView.
//

import SwiftUI
import SwiftData

struct WantsView: View {
    
    // Swift Data
    @Environment(\.modelContext) var context
    
        // Wants in data
        @Query(filter: #Predicate<ListItem> { item in
            item.isWant == true
        }) var wants: [ListItem]
    
    // Class Data
    @State private var isShowingSheet: Bool = false

    // UI
    var body: some View {
        
        NavigationStack {
            
            // MARK: - List of Wants
                List {
                    ForEach(wants, id: \.self) { want in
                        // If a want is tapped, bring up its information using WantView
                        NavigationLink(want.title) {
                            ListItemView(item: want)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .navigationTitle("Wants")
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
                                AddListItemView(isWant: true)
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.large])
                            }
                        }
                    // Cancel
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                            NavigationLink(destination: {
                                SettingsView()
                            }, label: {
                                Image(systemName: "gear")
                            })
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
       let container = try! ModelContainer(for: ListItem.self, configurations: config)

    return WantsView()
           .modelContainer(container)
}
