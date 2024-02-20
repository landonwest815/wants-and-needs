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
   
    // SwiftData
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Query var userSettingsArray: [UserSettings]
    @State private var accentColor: Color = .red

    // Passed in want
    let item: ListItem?
    let isWant: Bool?
    
    // User Inputs
    @State private var titleTextField: String = ""
    @State var price: Int?
    @State private var itemImage: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var itemURL: String = ""
    @State private var infoTextField: String = ""
    @FocusState var titleFocus: Bool
    @FocusState var additionalFocus: Bool
    @FocusState var priceFocus: Bool
    
    init(item: ListItem?) {
        self.item = item
        self.isWant = item?.isWant
    }
    
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
                
                // MARK: - Media Section
                    Section {
                        if let imageData = item != nil ? item?.itemImage : imageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 500)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(5)
                        }
                                                    
                            PhotosPicker(selection: $itemImage, matching: .images) {
                                Label("Select image", systemImage: "photo")
                            }
                                                        
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
                                                    
                        LinkPickerView(enteredLink: $itemURL)
                            .onChange(of: itemURL) {
                                    item?.itemURL = itemURL
                            }
                        
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
                
                
                
                    
                // MARK: - Additional Info Section
                    Section {
                        ZStack {
                            TextField("Anything Else?", text: $infoTextField, axis: .vertical)
                                .focused($additionalFocus)
                            Text(infoTextField).opacity(0).padding(.all, 8)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        
                                        Button("Done") {
                                            additionalFocus = false
                                            titleFocus = false
                                            priceFocus = false
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
                    
                } //: Form
            .navigationBarTitle(item?.title ?? "New Item")
            .toolbar {
                // Existing Details
                if item != nil {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            context.delete(item!)
                            dismiss()
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(userSettingsArray.first.map { Color(hex: $0.accentColor) } ?? .red)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.red)
                        .fontWeight(.heavy)
                    }
                }
                
                // New creation
                else {
                    // Add
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Add") {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            let item = ListItem(isWant: isWant ?? true, title: titleTextField, price: price, itemImage: imageData, itemURL: itemURL, info: infoTextField)
                            context.insert(item)
                            dismiss()
                        }
                        .disabled(titleTextField.isEmpty)
                    }
                    //Cancel
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        } //: NavigationStack
        .accentColor(accentColor)
        .onTapGesture{
            additionalFocus = false
            titleFocus = false
            priceFocus = false
        }
        .onAppear() {
            // Update with Pre-Existing Data
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
