//
//  NeedView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/20/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct NeedView: View {
    
    // SwiftData
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    // Passed in want
    let need: ListItem
    
    // User Inputs
    @State private var needTextField: String = ""
    @State private var needItem: PhotosPickerItem?
    @State private var infoTextField: String = ""
    
    // UI
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                // MARK: - Want Section
                    Section {
                        TextField("", text: $needTextField)
                            .multilineTextAlignment(.leading)
                            .onChange(of: needTextField) {
                                need.title = needTextField
                            }
                    }
                    header: {
                        Text("Need")
                    }
                
                // MARK: - Media Section
                    Section {
                        if let imageData = need.itemImage,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                            }
                        
                        PhotosPicker(selection: $needItem, matching: .images) {
                            Label("Select image", systemImage: "photo")
                        }
                        
                        if need.itemImage != nil {
                            Button(role: .destructive) {
                                withAnimation {
                                    needItem = nil
                                    need.itemImage = nil
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
                    .onChange(of: needItem) {
                        Task {
                            if let loaded = try? await needItem?.loadTransferable(type: Data.self) {
                                need.itemImage = loaded
                            } else {
                                print("Failed")
                            }
                        }
                        
                    }
                    
                // MARK: - Additional Section
                    Section {
                        TextField("", text: $infoTextField)
                            .onChange(of: infoTextField) {
                                need.info = infoTextField
                            }
                            .multilineTextAlignment(.leading)
                            .frame(height: 100, alignment: .top)
                    }
                    header: {
                        Text("Additional Comments")
                    }
                    
                } //: Form
                .navigationBarTitle(need.title)
                .toolbar {
                    Button {
                        context.delete(need)
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .foregroundColor(.red)
                    .fontWeight(.heavy)
                }
            } //: NavigationStack
            .onAppear() {
                // Update with Pre-Existing Data
                needTextField = need.title
                infoTextField = need.info ?? ""
            }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
       let container = try! ModelContainer(for: ListItem.self, configurations: config)

    let need = ListItem(isWant: false, title: "Test User")
       return NeedView(need: need)
           .modelContainer(container)
}
