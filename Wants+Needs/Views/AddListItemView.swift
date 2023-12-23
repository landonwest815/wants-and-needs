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

struct AddListItemView: View {
    
    // Want or Need?
    var isWant: Bool
    
    // SwiftData
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
        // Wants in data
        @Query(filter: #Predicate<ListItem> { item in
            item.isWant == true
        }) var wants: [ListItem]
        
        // Needs in data
        @Query(filter: #Predicate<ListItem> { item in
            item.isWant == false
        }) var needs: [ListItem]
    
    @Query var userSettingsArray: [UserSettings]
    
    // User Input
    @State private var title: String = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var info: String = ""
    
    @State private var accentColor: Color = .red

    // UI
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                // MARK: - Title
                    Section {
                        TextField("", text: $title)
                    }
                    header: {
                        Text(isWant ? "Want" : "Need")
                    }
                
                // MARK: - Media
                    Section {
                        if let imageData = imageData,
                            let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity, maxHeight: 300)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.top, 5)
                            }
                        
                        PhotosPicker(selection: $selectedImage, matching: .images) {
                            Label("Select image", systemImage: "photo")
                        }
                        
                        if imageData != nil {
                            Button(role: .destructive) {
                                withAnimation {
                                    selectedImage = nil
                                    imageData = nil
                                }
                            } label: {
                                Label("Remove Image", systemImage: "xmark")
                                    .foregroundColor(.red)
                            }
                        }
                        
                    }
                    header: {
                        Text("Media")
                    }
                    .onChange(of: selectedImage) {
                        Task {
                            if let loaded = try? await selectedImage?.loadTransferable(type: Data.self) {
                                imageData = loaded
                            } else {
                                print("Failed")
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                
                // MARK: - Additional
                    Section {
                        TextEditor(text: $info)
                                .frame(height: 150)
                    }
                    header: {
                        Text("Additional Comments")
                    }
                
            } //: Form
            .navigationBarTitle(isWant ? "New Want" : "New Need")
            .toolbar {
                // Add
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Add") {
                            let item = ListItem(isWant: isWant, title: title, itemImage: imageData, info: info)
                            context.insert(item)
                            dismiss()
                        }
                        .disabled(title.isEmpty)
                    }
                // Cancel
                ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
            }
        }
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

    return AddListItemView(isWant: false)
           .modelContainer(container)
}
