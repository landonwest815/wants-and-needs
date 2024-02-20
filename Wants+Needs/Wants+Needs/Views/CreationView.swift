//
//  AddListItemView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/21/23.
//
//  This View represents the additon of a new want
//  or need. This View is called with a Bool as a
//  parameter to differentiate between want and need.
//

import SwiftUI
import SwiftData
import PhotosUI

struct CreationView: View {
    
    // SwiftData
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Query var userSettingsArray: [UserSettings]
    @State private var accentColor: Color = .red
    
    // Want or Need?
    var isWant: Bool
    
    // User Input
    @State private var title: String = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var enteredURL: String = ""
    @State private var info: String = ""
    @FocusState var titleFocus: Bool
    @FocusState var additionalFocus: Bool

    // UI
    var body: some View {
        
//        NavigationView {
//            
//            Form {
//                
//                // MARK: - Title
//                    Section {
//                        TextField("What is it?", text: $title)
//                            .focused($titleFocus)
//                    }
//                    header: {
//                        Text(isWant ? "Want" : "Need")
//                    }
//                
//                // MARK: - Media
//                    Section {
//                        
//                        // Grab image data
//                        if let imageData = imageData,
//                            let uiImage = UIImage(data: imageData) {
//                                    Image(uiImage: uiImage)
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(maxWidth: .infinity, maxHeight: 500)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                                        .padding(5)
//                            }
//                        
//                        // Add image data
//                        PhotosPicker(selection: $selectedImage, matching: .images) {
//                            Label("Select image", systemImage: "photo")
//                        }
//                                
//                        // Option to remove if image exists
//                        if imageData != nil {
//                            Button(role: .destructive) {
//                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
//                                withAnimation {
//                                    selectedImage = nil
//                                    imageData = nil
//                                }
//                            } label: {
//                                Label("Remove Image", systemImage: "xmark")
//                                    .foregroundColor(.red)
//                            }
//                        }
//                        
//                        // URL functionality
//                        LinkPickerView(enteredLink: $enteredURL)
//                        
//                    }
//                    header: {
//                        Text("Media")
//                    }
//                    // Update image
//                    .onChange(of: selectedImage) {
//                        Task {
//                            if let loaded = try? await selectedImage?.loadTransferable(type: Data.self) {
//                                imageData = loaded
//                            } else {
//                                print("Failed")
//                            }
//                        }
//                    }
//                    .listRowSeparator(.hidden)
//                
//                // MARK: - Additional
//                    Section {
//                        ZStack {
//                            TextField("Anything Else?", text: $info, axis: .vertical)
//                                .focused($additionalFocus)
//                            Text(info).opacity(0).padding(.all, 8)
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
//                        }
//                    }
//                
//                    header: {
//                        Text("Additional Info")
//                    }
//                
//            } //: Form
//            .navigationBarTitle(isWant ? "New Want" : "New Need")
//            .toolbar {
//                // Add
//                ToolbarItemGroup(placement: .navigationBarTrailing) {
//                        Button("Add") {
//                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
//                            let item = ListItem(isWant: isWant, title: title, itemImage: imageData, itemURL: enteredURL, info: info)
//                            context.insert(item)
//                            dismiss()
//                        }
//                        .disabled(title.isEmpty)
//                    }
//                // Cancel
//                ToolbarItemGroup(placement: .navigationBarLeading) {
//                        Button("Cancel") {
//                            dismiss()
//                        }
//                    }
//            }
//        }
        ItemFormView(isWant: self.isWant)
        .onAppear() {
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
    let userSettings =  UserSettings()
    userSettings.accentColor = "ff0000"
    container.mainContext.insert(userSettings)

    return CreationView(isWant: false)
           .modelContainer(container)
}
