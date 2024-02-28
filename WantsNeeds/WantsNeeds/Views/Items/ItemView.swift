//
//  ItemThumbnailView.swift
//  Wants+Needs
//
//  Created by Landon West on 2/19/24.
//

import SwiftUI
import SwiftData

struct ItemView: View {
    
    // Pull Data
    @Environment(\.modelContext) var context
    @Query private var userData : [UserSettings]
    
    // Passed in Item to display
    var item: ListItem
    
    // Allows user to open up item details
    @State private var isShowingSheet: Bool = false
    
    // Prompts upon item deletion
    @State private var showConfirmation: Bool = false
    
    // Allows user to navigate directly to the webpage
    @State private var submittedLink: URL?
        
    var body: some View {
          
        VStack(spacing: 0) {
                HStack{
                    
                    // MARK: - Item Title (with optional Star)
                    HStack {
                        if item.favorite == true {
                            Image(systemName: "star.fill")
                                .foregroundStyle(Color(hex: userData.first?.accentColor ?? "FFFFFF") ?? .red)
                        }
                        Text(item.title)
                            .fontWeight(.semibold)
                            .font(.system(size:18))
                    }
                    
                    Spacer()
                    
                    // MARK: - Item Price (if applicable)
                    if item.price != nil && item.price != 0 {
                        Text("$\(item.price ?? 0)")
                            .fontWeight(.semibold)
                            .font(.system(size:16))
                    }
                    
                }
                .padding(12.5)
                
                // MARK: - Displayed Image
                if let imageData = item.itemImage,
                   let uiImage = UIImage(data: imageData) {
                    ZStack {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 12.5)) // Apply rounded corners to the clipped image
                            .overlay(
                                RoundedRectangle(cornerRadius: 12.5, style: .circular)
                                    .stroke(Color(uiColor: .systemGray3), lineWidth: 1)
                            )
                            .padding(.horizontal, 12.5)
                            .padding(.bottom, 12.5)
                        VStack {
                            
                            Spacer()
                            
                            // MARK: - Link (if applicable)
                            HStack() {
                                Spacer()
                                if let url = submittedLink {
                                        Link(destination: url) {
                                        Image(systemName: "link")
                                    }
                                }
                            }
                            
                        }
                        .padding(25)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .listRowSeparator(.hidden)
            .background(Color(uiColor: .systemGray6))
            .cornerRadius(17.5)
            .overlay(
                RoundedRectangle(cornerRadius: 17.5, style: .circular).stroke(Color(uiColor: .systemGray3), lineWidth: 1)
            )
            .onTapGesture {
                // Show details Form
                isShowingSheet.toggle()
            }
            .simultaneousGesture(TapGesture().onEnded{
                let impactMedium = UIImpactFeedbackGenerator(style: .medium)
                impactMedium.impactOccurred()
            })
            .sheet(isPresented: $isShowingSheet) {
                ZStack {                Color.black.edgesIgnoringSafeArea(.all)
                    ItemFormView(item: item)
                }                       .presentationDragIndicator(.visible)         .presentationDetents([.fraction(0.9)])
            }
        
            // Long Press Options
            .contextMenu {
                
                // MARK: - Quick Favorite
                Button {
                    item.favorite.toggle()
                } label: {
                    Label(item.favorite ? "Unfavorite" : "Favorite", systemImage: item.favorite ? "star" : "star.fill")
                }
                
                // MARK: - Quick Type Switch
                Button {
                    item.isWant.toggle()
                } label: {
                    Label("Switch to \(item.isWant ? "Need" : "Want")", systemImage: item.isWant ? "brain.fill" : "heart.fill")
                }
                
                // MARK: - Quick Deletion
                Button(role: .destructive) {
                    showConfirmation = true
                } label: {
                    Label("Delete \(item.isWant ? "Want" : "Need")", systemImage: "trash")
                }
                    
            }
        
            // Item deletion confirmation
            .confirmationDialog("Are you sure you want to delete this \(item.isWant ? "Want" : "Need")?", isPresented: $showConfirmation) {
                Button("Delete it!", role: .destructive, action: {
                        context.delete(item)
                })
                
                // This button overrides the default Cancel button.
                Button("Mmm.. nevermind", role: .cancel, action: {})
            }
            message: {
                Text("Careful! This action is permanent and cannot be undone.")
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 10)
            
            // Update Link information
            .onChange(of: item.itemURL) {
                submitLink()
            }
            .onAppear() {
                submitLink()
            }
    }
    
    // Resused from LinkPickerView()
    // Yes I know this is a bad thing and should be pulled out
    // into only one use.
    private func submitLink() {
        // Adjust the enteredLink to include "http://" if it doesn't already contain "http"
        if let enteredLink = item.itemURL {
            var linkToValidate = enteredLink
            if !linkToValidate.contains("http") {
                linkToValidate = "http://\(linkToValidate)"
            }
            
            // Basic check to see if the URL contains a dot after the protocol
            let hasDotAfterProtocol = linkToValidate.range(of: "http[s]?://[^/]+\\.", options: .regularExpression) != nil
            
            // Validate and convert the adjusted link to a URL
            if hasDotAfterProtocol, let url = URL(string: linkToValidate), UIApplication.shared.canOpenURL(url) {
                submittedLink = url
            } else {
                // Handle invalid URL
                print("Invalid URL")
                submittedLink = nil
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    
    let container = try! ModelContainer(for: ListItem.self, configurations: config)
    
    let image: UIImage = .checkmark
    
    let item = ListItem(isWant: true, title: "test", itemImage: image.pngData())
    container.mainContext.insert(item)
    return ItemView(item: item)
}
