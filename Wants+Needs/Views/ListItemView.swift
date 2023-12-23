//
//  ListItemView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/21/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ListItemView: View {
    
    // SwiftData
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @Query var userSettingsArray: [UserSettings]

    // Passed in want
    let item: ListItem
    
    // User Inputs
    @State private var titleTextField: String = ""
    @State private var itemImage: PhotosPickerItem?
    @State private var infoTextField: String = ""
    
    // UI
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                // MARK: - Title Section
                    Section {
                        TextField("", text: $titleTextField)
                            .onChange(of: titleTextField) {
                                item.title = titleTextField
                            }
                    }
                    header: {
                        Text(item.isWant ? "Want" : "Need")
                    }
                
                // MARK: - Media Section
                    Section {
                        if let imageData = item.itemImage,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.top, 5)
                            }
                        
                        PhotosPicker(selection: $itemImage, matching: .images) {
                            Label("Select image", systemImage: "photo")
                        }
                        
                        if item.itemImage != nil {
                            Button(role: .destructive) {
                                withAnimation {
                                    itemImage = nil
                                    item.itemImage = nil
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
                    .onChange(of: itemImage) {
                        Task {
                            if let loaded = try? await itemImage?.loadTransferable(type: Data.self) {
                                item.itemImage = loaded
                            } else {
                                print("Failed")
                            }
                        }
                        
                    }
                    .listRowSeparator(.hidden)
                    
                // MARK: - Additional Section
                    Section {
                        TextEditor(text: $infoTextField)
                                .frame(height: 150)
                            .onChange(of: infoTextField) {
                                item.info = infoTextField
                            }
                            .multilineTextAlignment(.leading)
                            .frame(height: 100, alignment: .top)
                    }
                    header: {
                        Text("Additional Comments")
                    }
                    
                } //: Form
                .navigationBarTitle(item.title)
                .toolbar {
                    Button {
                        context.delete(item)
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(userSettingsArray.first.map { Color(hex: $0.accentColor) } ?? .red)
                            .fontWeight(.medium)

                    }
                    .foregroundColor(.red)
                    .fontWeight(.heavy)
                }
            } //: NavigationStack
            .onAppear() {
                // Update with Pre-Existing Data
                titleTextField = item.title
                infoTextField = item.info ?? ""
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
    
    return ListItemView(item: item)
           .modelContainer(container)
}
