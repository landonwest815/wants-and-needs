//
//  NeedsView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/19/23.
//

import SwiftUI
import SwiftData

struct NeedsView: View {
    
    // Swift Data
    @Environment(\.modelContext) var context
        
        // Needs in data
        @Query(filter: #Predicate<ListItem> { item in
            item.isWant == false
        }) var needs: [ListItem]
    
    // Class Data
    @State private var isShowingSheet: Bool = false

    // UI
    var body: some View {
        
        NavigationStack {
            
            // MARK: - List of Needs
                Form {
                    ForEach(needs, id: \.self) { need in
                        // If a need is tapped, bring up its information using NeedView
                        Section {
                            NavigationLink(need.title) {
                                ListItemView(item: need)
                            }.padding(5)
                            
                            if let imageData = need.itemImage,
                               let uiImage = UIImage(data: imageData) {
                                VStack {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: 200, maxHeight: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.bottom, 10)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .deleteDisabled(true)
                                .background(
                                    NavigationLink("", destination: ListItemView(item: need))
                                        .opacity(0)
                                    )
                            
                            }
                        }
                        .listSectionSpacing(10)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: delete)
                }
                .navigationTitle("Needs")
                .toolbar {
                    // Add
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        // MARK: - Add Need
                            Button {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                isShowingSheet.toggle()
                            } label: {
                                Image(systemName: "pencil")
                                    .fontWeight(.heavy)
                            }
                            .sheet(isPresented: $isShowingSheet) {
                                AddListItemView(isWant: false)
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
                                    .fontWeight(.medium)
                            })
                            .simultaneousGesture(TapGesture().onEnded{
                                let impactMedium = UIImpactFeedbackGenerator(style: .medium)
                                impactMedium.impactOccurred()
                            })
                            
                            
                    
                        }
                    
                }
                
        }
        
    }

    // MARK: - Delete Need
    func delete(_ indexSet: IndexSet) {
        for i in indexSet {
            let need = needs[i]
            context.delete(need)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
       let container = try! ModelContainer(for: ListItem.self, configurations: config)

    return NeedsView()
           .modelContainer(container)
}
