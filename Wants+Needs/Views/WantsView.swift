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
                Form {
                    ForEach(wants, id: \.self) { want in
                        // If a want is tapped, bring up its information using WantView
                        Section {
                            NavigationLink(want.title) {
                                ListItemView(item: want)
                            }.padding(5)
                            
                            if let imageData = want.itemImage,
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
                                            NavigationLink("", destination: ListItemView(item: want))
                                                .opacity(0)
                                            )
                            
                            }
                        }
                        .listSectionSpacing(10)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: delete)
                }
                .navigationTitle("Wants")
                .toolbar {
                    // Add
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        // MARK: - Add Want
                            Button {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                isShowingSheet.toggle()
                            } label: {
                                Image(systemName: "pencil")
                                    .fontWeight(.heavy)
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
    let container = try! ModelContainer(for: ListItem.self, UserSettings.self, configurations: config)
    let item =  ListItem(isWant: true, title: "basketball")
    container.mainContext.insert(item)
    let settings = UserSettings()
    container.mainContext.insert(settings)

    return WantsView()
           .modelContainer(container)
}
