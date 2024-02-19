//
//  ItemThumbnailView.swift
//  Wants+Needs
//
//  Created by Landon West on 2/19/24.
//

import SwiftUI
import SwiftData

struct ItemThumbnailView: View {
    
    var item: ListItem
    @State private var isShowingSheet: Bool = false
    
    var body: some View {
            // If a want is tapped, bring up its information using WantView
//            Section {
//                NavigationLink(item.title) {
//                    ListItemView(item: item)
//                }
//                
//                if let imageData = item.itemImage,
//                   let uiImage = UIImage(data: imageData) {
//                    HStack {
//                        Image(uiImage: uiImage)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .padding(.bottom, 10)
//                            .padding(.leading, 5)
//                            .padding(.trailing, 5)
//
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .deleteDisabled(true)
//                    .background(
//                                NavigationLink("", destination: ListItemView(item: item))
//                                    .opacity(0)
//                                )
//                
//                }
//            }
//            .listSectionSpacing(25)
//            .listRowSeparator(.hidden)
        
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
            .cornerRadius(12.5)
            .overlay(
                RoundedRectangle(cornerRadius: 12.5, style: .circular).stroke(Color(uiColor: .systemGray3), lineWidth: 1)
            )
            .onTapGesture {
                isShowingSheet.toggle()
            }
            .sheet(isPresented: $isShowingSheet) {
                ListItemView(item: item)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.large])
            }
        
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
       let container = try! ModelContainer(for: ListItem.self, configurations: config)
    
    let image: UIImage = .checkmark
    
    let item = ListItem(isWant: true, title: "test", itemImage: image.pngData())
    container.mainContext.insert(item)
    return ItemThumbnailView(item: item)
}
