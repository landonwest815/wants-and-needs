//
//  ListItemView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/21/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ItemDetailsView: View {
    
    // SwiftData
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Query var userSettingsArray: [UserSettings]
    @State private var accentColor: Color = .red

    // Passed in want
    let item: ListItem
    
    // User Inputs
    @State private var titleTextField: String = ""
    @State private var itemImage: PhotosPickerItem?
    @State private var itemURL: String = ""
    @State private var infoTextField: String = ""
    @FocusState var titleFocus: Bool
    @FocusState var additionalFocus: Bool
    
    // UI
    var body: some View {
        
//        NavigationView {
//            
//            Form {
//                
//                // MARK: - Title Section
//                    Section {
//                        TextField("", text: $titleTextField)
//                            .focused($titleFocus)
//                            .onChange(of: titleTextField) {
//                                item.title = titleTextField
//                            }
//                    }
//                    header: {
//                        Text(item.isWant ? "Want" : "Need")
//                    }
//                
//                Section {
//                    
//                }
//                
//                // MARK: - Media Section
//                    Section {
//                        if let imageData = item.itemImage,
//                           let uiImage = UIImage(data: imageData) {
//                            Image(uiImage: uiImage)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(maxWidth: .infinity, maxHeight: 500)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                .padding(5)
//                        }
//                                                    
//                            PhotosPicker(selection: $itemImage, matching: .images) {
//                                Label("Select image", systemImage: "photo")
//                            }
//                                                        
//                            if item.itemImage != nil {
//                                Button(role: .destructive) {
//                                    withAnimation {
//                                        itemImage = nil
//                                        item.itemImage = nil
//                                    }
//                                } label: {
//                                    Label("Remove Image", systemImage: "xmark")
//                                        .foregroundColor(.red)
//                                }
//                            }
//                                                    
//                        LinkPickerView(enteredLink: $itemURL)
//                            .onChange(of: itemURL) {
//                                item.itemURL = itemURL
//                            }
//                        
//                    }
//                    header: {
//                        Text("Media")
//                    }
//                    .onChange(of: itemImage) {
//                        Task {
//                            if let loaded = try? await itemImage?.loadTransferable(type: Data.self) {
//                                item.itemImage = loaded
//                            } else {
//                                print("Failed")
//                            }
//                        }
//                        
//                    }
//                    .listRowSeparator(.hidden)
//                
//                
//                
//                    
//                // MARK: - Additional Info Section
//                    Section {
//                        ZStack {
//                            TextField("Anything Else?", text: $infoTextField, axis: .vertical)
//                                .focused($additionalFocus)
//                            Text(infoTextField).opacity(0).padding(.all, 8)
//                                .toolbar {
//                                    ToolbarItemGroup(placement: .keyboard) {
//                                        Spacer()
//                                        
//                                        Button("Done") {
//                                            additionalFocus = false
//                                            titleFocus = false
//                                        }
//                                    }
//                                }
//                                .onChange(of: infoTextField) {
//                                    item.info = infoTextField
//                                }
//                        }
//                    }
//                    header: {
//                        Text("Additional Comments")
//                    }
//                    
//                } //: Form
//                .navigationBarTitle(item.title)
//                .toolbar {
//                    Button {
//                        context.delete(item)
//                        dismiss()
//                    } label: {
//                        Image(systemName: "trash")
//                            .foregroundColor(userSettingsArray.first.map { Color(hex: $0.accentColor) } ?? .red)
//                            .fontWeight(.medium)
//
//                    }
//                    .foregroundColor(.red)
//                    .fontWeight(.heavy)
//                }
//            } //: NavigationStack
        ItemFormView(item: self.item)
            .onAppear() {
                // Update with Pre-Existing Data
                titleTextField = item.title
                infoTextField = item.info ?? ""
                itemURL = item.itemURL ?? ""
                if let userSettings = userSettingsArray.first {
                    accentColor = Color(hex: userSettings.accentColor) ?? .red
                }
            }
            .accentColor(accentColor)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ListItem.self, UserSettings.self, configurations: config)
    let item = ListItem(isWant: true, title: "Test Item")
    let userSettings =  UserSettings()
    userSettings.accentColor = "ff0000"
    container.mainContext.insert(userSettings)
    
    return ItemDetailsView(item: item)
           .modelContainer(container)
}
