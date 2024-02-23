//
//  ItemThumbnailView.swift
//  Wants+Needs
//
//  Created by Landon West on 2/19/24.
//

import SwiftUI
import SwiftData

struct ExpandedItemView: View {
    
    @Environment(\.modelContext) var context
    var item: ListItem
    @State private var isShowingSheet: Bool = false
    @State private var showConfirmation: Bool = false
    @State private var submittedLink: URL?
        
    var body: some View {
          
        ZStack {
            ItemFormView(item: item)
        }
        .frame(maxHeight: .infinity)
        .listRowSeparator(.hidden)
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(17.5)
        .overlay(
            RoundedRectangle(cornerRadius: 17.5, style: .circular).stroke(Color(uiColor: .systemGray3), lineWidth: 1)
        )
        .contextMenu {
            Button {
                item.isWant.toggle()
            } label: {
                Label("Switch to \(item.isWant ? "Need" : "Want")", systemImage: item.isWant ? "brain.fill" : "heart.fill")
            }
            
            Button(role: .destructive) {
                showConfirmation = true
            } label: {
                Label("Delete \(item.isWant ? "Want" : "Need")", systemImage: "trash")
            }
                
        }
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
        .onChange(of: item.itemURL) {
            submitLink()
        }
        .onAppear() {
            submitLink()
        }
            
    }
    
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
    return ExpandedItemView(item: item)
}
