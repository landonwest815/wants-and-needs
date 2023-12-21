//
//  AddWantView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/20/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddWantView: View {
    
    // SwiftData
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Query var wants: [Want]
    
    // User Input
    @State private var want: String = ""
    @State private var wantItem: PhotosPickerItem?
    @State private var wantImage: Data?
    @State private var info: String = ""

    // UI
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                // MARK: - Want
                    Section {
                        TextField("", text: $want)
                            .multilineTextAlignment(.leading)
                    }
                    header: {
                            Text("Want")
                    }
                
                // MARK: - Media
                    Section {
                        if let imageData = wantImage,
                            let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 300)
                            }
                        
                        PhotosPicker(selection: $wantItem, matching: .images) {
                            Label("Select image", systemImage: "photo")
                        }
                        
                        if wantImage != nil {
                            Button(role: .destructive) {
                                withAnimation {
                                    wantItem = nil
                                    wantImage = nil
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
                                wantImage = loaded
                            } else {
                                print("Failed")
                            }
                        }
                    }
                
                // MARK: - Additional
                    Section {
                        TextField("", text: $info)
                            .multilineTextAlignment(.leading)
                            .frame(height: 150, alignment: .top)
                    }
                    header: {
                        Text("Additional Comments")
                    }
                
            } //: Form
            .navigationBarTitle("New Want")
            .toolbar {
                // Add
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Add") {
                            let want = Want(want: want, wantImage: wantImage, info: info)
                            context.insert(want)
                            dismiss()
                        }
                        .disabled(want.isEmpty)
                    }
                // Cancel
                ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
       let container = try! ModelContainer(for: Want.self, configurations: config)

       return AddWantView()
           .modelContainer(container)
}
