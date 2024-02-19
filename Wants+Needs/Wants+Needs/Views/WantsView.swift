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
    
        // Needs in data
        @Query(filter: #Predicate<ListItem> { item in
            item.isWant == false
        }) var needs: [ListItem]
    
    @Query var userData: [UserSettings]
    
    // Class Data
    @State private var isShowingSheet: Bool = false
    @State private var wantsSelected: Bool = true

    // UI
    var body: some View {
        
        NavigationStack {
            let accent = Color(hex: userData.first?.accentColor ?? "#FFFFFF") ?? .pink
            
            // MARK: - List of Wants
            ScrollView {
                
                HStack(spacing: 20) {
                   
                    VStack {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(wantsSelected ? accent : .white)
                        Text("Wants")
                    }
                        .fontWeight(.bold)
                        .font(wantsSelected ? .title : .title2)
                        .opacity(wantsSelected ? 1.0 : 0.25)
                        .scaleEffect(wantsSelected ? 1.1 : 1.0)
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                    wantsSelected = true
                                    }
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            let impactMedium = UIImpactFeedbackGenerator(style: .medium)
                            impactMedium.impactOccurred()
                        })
                    
                    VStack {
                        Image(systemName: "brain.fill")
                            .foregroundStyle(!wantsSelected ? accent : .white)
                        Text("Needs")
                    }
                        .fontWeight(.bold)
                        .font(wantsSelected ? .title2 : .title)
                        .opacity(wantsSelected ? 0.25 : 1.0)
                        .scaleEffect(!wantsSelected ? 1.1 : 1.0)
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                wantsSelected = false
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            let impactMedium = UIImpactFeedbackGenerator(style: .medium)
                            impactMedium.impactOccurred()
                        })
                        
                }
                .frame(width: 300, height:100)
                     
                VStack {
                    if wantsSelected ? wants.isEmpty : needs.isEmpty {
                        // Placeholder to maintain layout when there are no items
                        Text("Tap that pencil in the corner!")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100) // Adjust as needed
                            .opacity(0.5)
                    } else {
                        ForEach(wantsSelected ? wants : needs, id: \.self) { item in
                            
                            ItemThumbnailView(item: item)
                                .padding(.horizontal, 30)
                                .padding(.bottom, 20)
                                .transition(.move(edge: wantsSelected ? .leading : .trailing))
                                .scrollTransition { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1 : 0.85)
                                        .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                        .blur(radius: phase.isIdentity ? 0 : 1)
                                }
                            
                            // If a want is tapped, bring up its information using WantView
                            //                        Section {
                            //                            NavigationLink(want.title) {
                            //                                ListItemView(item: want)
                            //                            }
                            //                            .padding(5)
                            //
                            //                            if let imageData = want.itemImage,
                            //                               let uiImage = UIImage(data: imageData) {
                            //                                HStack {
                            //                                    Image(uiImage: uiImage)
                            //                                        .resizable()
                            //                                        .aspectRatio(contentMode: .fill)
                            //                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                            //                                        .padding(.bottom, 10)
                            //                                        .padding(.leading, 5)
                            //                                        .padding(.trailing, 5)
                            //
                            //                                }
                            //                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            //                                .deleteDisabled(true)
                            //                                .background(
                            //                                            NavigationLink("", destination: ListItemView(item: want))
                            //                                                .opacity(0)
                            //                                            )
                            //
                            //                            }
                            //                        }
                            //                        .listSectionSpacing(25)
                            //                        .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: delete)
                        
                    }
                    Spacer()
                }
                .frame(minHeight: 200)
                }
            .frame(minWidth: 100, minHeight: 500)
                .scrollIndicators(.hidden)
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
                                    .foregroundStyle(accent)
                            }
                            .sheet(isPresented: $isShowingSheet) {
                                AddListItemView(isWant: wantsSelected)
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.large])
                            }
                        }
                    // Cancel
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                            NavigationLink(destination: {
                                SettingsView()
                                    .toolbar(.hidden, for: .tabBar)
                            }, label: {
                                Image(systemName: "gear")
                                    .fontWeight(.medium)
                                    .foregroundStyle(accent)
                            })
                            .simultaneousGesture(TapGesture().onEnded{
                                let impactMedium = UIImpactFeedbackGenerator(style: .medium)
                                impactMedium.impactOccurred()
                            })
                            
                            
                    
                        }
                    
                    
                }
                .toolbarBackground(.hidden, for: .navigationBar)
                
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
