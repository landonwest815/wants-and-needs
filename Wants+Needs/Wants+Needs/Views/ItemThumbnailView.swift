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
        
            VStack(alignment: .leading, spacing: 0){
                HStack{
                    Text(item.title)
                    Spacer()
                }
                .padding(15)
                
                if let imageData = item.itemImage,
                   let uiImage = UIImage(data: imageData) {
                    HStack {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.bottom, 10)
                            .padding(.leading, 5)
                            .padding(.trailing, 5)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 250)
                }
            }
            .background(Color(uiColor: .systemGray5))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .circular).stroke(Color(uiColor: .tertiaryLabel), lineWidth: 1)
            )
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
