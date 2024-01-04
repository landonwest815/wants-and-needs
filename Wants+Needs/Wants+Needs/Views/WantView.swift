//
//  WantView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/19/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct WantView: View {
    
    // SwiftData
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    // Passed in want
    let want: ListItem
    
    // User Inputs
    @State private var wantTextField: String = ""
    @State private var wantItem: PhotosPickerItem?
    @State private var infoTextField: String = ""
    
    // UI
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                // MARK: - Want Section
                    Section {
                        TextField("", text: $wantTextField)
                            .multilineTextAlignment(.leading)
                            .onChange(of: wantTextField) {
                                want.title = wantTextField
                            }
                    }
                    header: {
                        Text("Want")
                    }
                
                // MARK: - Media Section
                    Section {
                        if let imageData = want.itemImage,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                            }
                        
                        PhotosPicker(selection: $wantItem, matching: .images) {
                            Label("Select image", systemImage: "photo")
                        }
                        
                        if want.itemImage != nil {
                            Button(role: .destructive) {
                                withAnimation {
                                    wantItem = nil
                                    want.itemImage = nil
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
                    .onChange(of: wantItem) {
                        Task {
                            if let loaded = try? await wantItem?.loadTransferable(type: Data.self) {
                                want.itemImage = loaded
                            } else {
                                print("Failed")
                            }
                        }
                        
                    }
                    
                // MARK: - Additional Section
                    Section {
                        TextField("", text: $infoTextField)
                            .onChange(of: infoTextField) {
                                want.info = infoTextField
                            }
                            .multilineTextAlignment(.leading)
                            .frame(height: 100, alignment: .top)
                    }
                    header: {
                        Text("Additional Comments")
                    }
                    
                } //: Form
                .navigationBarTitle(want.title)
                .toolbar {
                    Button {
                        context.delete(want)
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
                wantTextField = want.title
                infoTextField = want.info ?? ""
            }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
       let container = try! ModelContainer(for: ListItem.self, configurations: config)

    let want = ListItem(isWant: true, title: "Test User")
       return WantView(want: want)
           .modelContainer(container)
}
