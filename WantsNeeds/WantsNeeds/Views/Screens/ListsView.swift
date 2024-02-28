//
//  WantsView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/19/23.
//
//  This class represents the View for displaying all the Wants and Needs currently in the User's SwiftData.
//  Items can be added and deleted from here
//  and will be updated in real time. Adding items
//  will present CreationView.
//

import SwiftUI
import SwiftData

struct ListsView: View {
    
    // Swift Data
    @Environment(\.modelContext) var context
    
    // All Wants in Data
    @Query(filter: #Predicate<ListItem> { item in
        item.isWant == true
    },     sort: [SortDescriptor(\ListItem.favorite, order: .reverse)]) var wants: [ListItem]
    
    // All Needs in Data
    @Query(filter: #Predicate<ListItem> { item in
        item.isWant == false
    },     sort: [SortDescriptor(\ListItem.favorite, order: .reverse)]) var needs: [ListItem]
    
    // User Settings
    @Query var userData: [UserSettings]
    
    // Presents sheet for Item Details
    @State private var isShowingSheet: Bool = false
    
    // Determines word usage and List Indicator at top of view
    @State private var wantsSelected: Bool = true
    
    // UI
    var body: some View {
        
        NavigationStack {
            
            // Grab the accent color from data
            let accent = Color(hex: userData.first?.accentColor ?? "#ff0000") ?? .pink
            
            ScrollView {
                
                HStack(spacing: 15) {
                    
                    // MARK: - Wants Tab
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
                    
                    // animation + haptic
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                            wantsSelected = true
                        }
                    }
                    .simultaneousGesture(TapGesture().onEnded{
                        let impactMedium = UIImpactFeedbackGenerator(style: .medium)
                        impactMedium.impactOccurred()
                    })
                    
                    // MARK: - Needs Tab
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
                    
                    // animation + haptic
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
                
                // MARK: - List of Selected Items
                VStack {
                    
                    // Check if there are any first
                    if wantsSelected ? wants.isEmpty : needs.isEmpty {
                        // Placeholder to maintain layout when there are no items
                        Text("Tap that pencil in the corner!")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                            .opacity(0.5)
                    } else {
                        
                        // Pull all the data
                        ForEach(wantsSelected ? wants : needs, id: \.self) { item in
                            
                            ItemView(item: item)
                                .frame(maxHeight: .infinity)
                            
                            // animation + effects
                                .transition(.move(edge: wantsSelected ? .leading : .trailing))
                                .scrollTransition { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1 : 0.8)
                                        .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                        .blur(radius: phase.isIdentity ? 0 : 1.5)
                                }
                        }
                    }
                    Spacer()
                }
                .frame(maxHeight: .infinity)
            }
            .frame(minWidth: 100, minHeight: 500)
            .scrollIndicators(.hidden)
            .toolbar {
                
                // MARK: - Item Addition (pencil)
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
                        ZStack {
                            Color.black.edgesIgnoringSafeArea(.all)
                            ItemFormView(isWant: wantsSelected)
                        }
                            .presentationDragIndicator(.visible)
                            .presentationDetents([.fraction(0.9)])
                    }
                }
                
                // MARK: - Settings (gear)
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    NavigationLink(destination: {
                        SettingsView()
                            .toolbar(.hidden, for: .tabBar)
                    }, label: {
                        Image(systemName: "gear")
                            .fontWeight(.semibold)
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
        
        // Allow for swipe gesture
        .gesture(DragGesture()
            .onEnded { value in
                print("value ",value.translation.width)
                let direction = self.detectDirection(value: value)
                if direction == .left && !wantsSelected {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        wantsSelected = true
                    }
                }
                if direction == .right && wantsSelected {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        wantsSelected = false
                    }
                }
            }
        )
    }
    
    
    // The following is from: https://stackoverflow.com/questions/59109138/how-to-implement-a-left-or-right-draggesture-that-trigger-a-switch-case-in-swi
    
    enum SwipeHVDirection: String {
        case left, right, up, down, none
    }
    
    func detectDirection(value: DragGesture.Value) -> SwipeHVDirection {
        if value.startLocation.x < value.location.x - 24 {
            return .left
        }
        if value.startLocation.x > value.location.x + 24 {
            return .right
        }
        if value.startLocation.y < value.location.y - 24 {
            return .down
        }
        if value.startLocation.y > value.location.y + 24 {
            return .up
        }
        return .none
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    
    let container = try! ModelContainer(for: ListItem.self, UserSettings.self, configurations: config)
    let item =  ListItem(isWant: true, title: "basketball")
    container.mainContext.insert(item)
    let settings = UserSettings()
    container.mainContext.insert(settings)

    return ListsView()
           .modelContainer(container)
}
