//
//  ItemThumbnailView.swift
//  Wants+Needs
//
//  Created by Landon West on 2/19/24.
//

import SwiftUI
import SwiftData

struct ItemView: View {
    
    @Environment(\.modelContext) var context
    var item: ListItem
    @State private var isShowingSheet: Bool = false
    @State private var showConfirmation: Bool = false
    
    var body: some View {
          
            VStack(alignment: .leading, spacing: 0) {
                HStack{
                    Text(item.title)
                        .fontWeight(.semibold)
                        .font(.system(size:18))
                    Spacer()
                }
                .padding(12.5)
                
                if let imageData = item.itemImage,
                   let uiImage = UIImage(data: imageData) {
                    HStack {
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
                isShowingSheet.toggle()
            }
            .sheet(isPresented: $isShowingSheet) {
                ItemDetailsView(item: item)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.large])
            }
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
