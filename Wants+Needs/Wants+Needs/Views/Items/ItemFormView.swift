//
//  ItemFormView.swift
//  Wants+Needs
//
//  Created by Landon West on 2/20/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ItemFormView: View {
   
    // Closes Confirmations or Opened Views
    @Environment(\.dismiss) var dismiss
    
    // Pull Data
    @Environment(\.modelContext) var context
    @Query var userSettingsArray: [UserSettings]
    
    // Default the accent color to red
    // This gets set during onAppear()
    @State private var accentColor: Color = .red

    // Passed in data for an existing item
    let item: ListItem?
    
    // Passed in data for a new item
    let isWant: Bool?
    
    // User Inputs
    @State private var favorited: Bool = false // not on default
    @State private var titleTextField: String = ""
    @State var price: Int?
    @State private var itemImage: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var itemURL: String = ""
    @State private var infoTextField: String = ""
    
    // Allows keyboard dismissal using "done" toolbar button
    @FocusState var titleFocus: Bool
    @FocusState var additionalFocus: Bool
    @FocusState var priceFocus: Bool
    @FocusState var urlFocus: Bool
    
    // Prompts the deletion confirmation
    @State private var showConfirmation: Bool = false
    
    // For existing items
    init(item: ListItem?) {
        self.item = item
        self.isWant = item?.isWant
    }
    
    // For item creation
    init(isWant: Bool) {
        self.item = nil
        self.isWant = isWant
    }
    
    // UI
    var body: some View {
        
        NavigationView {
            
            Form {
                
                // MARK: - Title Section
                    Section {
                        TextField("What is it?", text: $titleTextField)
                            .focused($titleFocus)
                            .onChange(of: titleTextField) {
                                item?.title = titleTextField
                            }
                    }
                    header: {
                        Text(self.isWant ?? true ? "Want" : "Need")
                    }
                    .listRowBackground(Color(.systemGray5))
                
                // MARK: - Price Section
                    Section {
                        TextField("Amount", value: $price, format: .number)
                            .focused($priceFocus)
                            .keyboardType(.numberPad)
                            .onChange(of: price) {
                                self.item?.price = price
                            }
                    }
                    header: {
                        Text("Price")
                    }
                    .listRowBackground(Color(.systemGray5))
                
                // MARK: - Media Section
                    Section {
                        // MARK: - Displayed Image
                        // Display image if data is valid
                        if let imageData = item != nil ? item?.itemImage : imageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 500)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(5)
                        }
                        
                        // MARK: - Image Picker
                        PhotosPicker(selection: $itemImage, matching: .images) {
                            Label("Select image", systemImage: "photo")
                        }
                              
                        // MARK: - Image Deletion
                        // Allow photo deletion after photo insertion
                        if item?.itemImage != nil || imageData != nil {
                                Button(role: .destructive) {
                                    withAnimation {
                                        itemImage = nil
                                        imageData = nil
                                        item?.itemImage = nil
                                    }
                                } label: {
                                    Label("Remove Image", systemImage: "xmark")
                                        .foregroundColor(.red)
                                }
                        }
                                    
                        // MARK: - Link Picker
                        LinkPickerView(enteredLink: $itemURL)
                            .onChange(of: itemURL) {
                                item?.itemURL = itemURL
                                try? context.save()
                            }
                            .focused($titleFocus)
                    }
                    header: {
                        Text("Media")
                    }
                    .onChange(of: itemImage) {
                        Task {
                            if let loaded = try? await itemImage?.loadTransferable(type: Data.self) {
                                if item != nil {
                                    item?.itemImage = loaded
                                } else {
                                    imageData = loaded
                                }
                            } else {
                                print("Failed")
                            }
                        }
                        
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color(.systemGray5))
                
                // MARK: - Additional Info Section
                    Section {
                        ZStack {
                            TextField("Anything Else?", text: $infoTextField, axis: .vertical)
                                .focused($additionalFocus)
                            // This allows for movement to the next line
                            Text(infoTextField).opacity(0).padding(.all, 8)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        
                                        // Unfocus all inputs to dismiss the keyboard
                                        Button("Done") {
                                            additionalFocus = false
                                            titleFocus = false
                                            priceFocus = false
                                            urlFocus = false
                                        }
                                    }
                                }
                                .onChange(of: infoTextField) {
                                        item?.info = infoTextField
                                }
                        }
                    }
                    header: {
                        Text("Additional Comments")
                    }
                    .listRowBackground(Color(.systemGray5))
                    
                } //: Form
                .frame(maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                .background(Color(.systemGray6))
                .toolbar {
                    
                    // Existing Details
                    if item != nil {
                        
                        // MARK: - Favorite Button
                        ToolbarItemGroup(placement: .topBarLeading) {
                            Button {
                                item?.favorite.toggle()
                                favorited.toggle()
                            } label: {
                                Image(systemName: favorited ? "star.fill" : "star")
                                    .foregroundColor(userSettingsArray.first.map { Color(hex: $0.accentColor) } ?? .red)
                                    .fontWeight(.medium)
                            }
                            .fontWeight(.heavy)
                            .simultaneousGesture(TapGesture().onEnded{
                                let impactMedium = UIImpactFeedbackGenerator(style: .medium)
                                impactMedium.impactOccurred()
                            })
                        }
                        
                        // MARK: - Delete Button
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            Button {
                                showConfirmation = true
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(userSettingsArray.first.map { Color(hex: $0.accentColor) } ?? .red)
                                    .fontWeight(.medium)
                            }
                            .fontWeight(.heavy)
                            .simultaneousGesture(TapGesture().onEnded{
                                let impactMedium = UIImpactFeedbackGenerator(style: .medium)
                                impactMedium.impactOccurred()
                            })
                        }
                    }
            
                    // New creation
                    else {
        
                        // MARK: - Cancel New Item Button
                        ToolbarItemGroup(placement: .topBarLeading) {
                            Button("Cancel") {
                                dismiss()
                            }
                        }
                        
                        // MARK: - Add New Item Button
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            Button("Add") {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                let item = ListItem(isWant: isWant ?? true, favorite: favorited, title: titleTextField, price: price, itemImage: imageData, itemURL: itemURL, info: infoTextField)
                                context.insert(item)
                                dismiss()
                            }
                            // don't allow empty title
                            .disabled(titleTextField.isEmpty)
                        }
                    }
                }
                .confirmationDialog("Are you sure you want to delete this \(item?.isWant ?? false ? "Want" : "Need")?", isPresented: $showConfirmation) {
                    Button("Delete it!", role: .destructive, action: {
                        if let deletedItem = item {
                            context.delete(deletedItem)
                        } else {
                            dismiss()
                        }
                    })
                    
                    // This button overrides the default Cancel button.
                    Button("Mmm.. nevermind", role: .cancel, action: {})
                }
                message: {
                    Text("Careful! This action is permanent and cannot be undone.")
                }
            } //: NavigationStack
            .cornerRadius(17.5)
            .overlay(
                RoundedRectangle(cornerRadius: 17.5, style: .circular).stroke(Color(uiColor: .systemGray3), lineWidth: 1)
            )
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 15)
            .padding(.bottom, 15)
            .padding(.top, 1)
            .accentColor(accentColor)
            .onAppear() {
                // Update with Pre-Existing Data
                favorited = item?.favorite ?? false
                titleTextField = item?.title ?? ""
                price = item?.price ?? nil
                infoTextField = item?.info ?? ""
                itemURL = item?.itemURL ?? ""
                
                if let userSettings = userSettingsArray.first {
                    accentColor = Color(hex: userSettings.accentColor) ?? .red
                }
            }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    
    let container = try! ModelContainer(for: ListItem.self, UserSettings.self, configurations: config)
    let item = ListItem(isWant: true, title: "Test Item")
    let userSettings =  UserSettings()
    userSettings.accentColor = "ff0000"
    container.mainContext.insert(userSettings)
    
    return ItemFormView(item: item)
           .modelContainer(container)
}
