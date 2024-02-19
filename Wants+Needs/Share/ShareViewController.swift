//
//  ShareViewController.swift
//  Share
//
//  Created by Landon West on 2/15/24.
//

import UIKit
import Social
import SwiftUI
import SwiftData
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true
        
        if let itemProviders = (extensionContext!.inputItems.first as? NSExtensionItem)?.attachments {
            let hostingView = UIHostingController(rootView: ShareView(itemProviders: itemProviders, extensionContext: extensionContext))
            hostingView.view.frame = view.frame
            view.addSubview(hostingView.view)
        }
    }
}

fileprivate struct ShareView: View {
    var itemProviders: [NSItemProvider]
    var extensionContext: NSExtensionContext?
    @State private var items: [ImageItem] = []
    @State private var titleTextField: String = ""
    @State private var type = 0
    @State private var imageView: UIImage = .add
    
    var body: some View {
        
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 15) {
                Text("")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Button("Cancel", action: dismiss)
                            .tint(.red)
                    }
                    .padding(.bottom, 10)
                
                Picker("Want or Need?", selection: $type) {
                    Image(systemName: "heart.fill")
                        .tag(0)
                    Image(systemName: "brain.fill")
                        .tag(1)
                }
                .pickerStyle(.segmented)
                    
                Form {
                    Section {
                        TextField("", text: $titleTextField)
                    }
                header: {
                    Text("What is it?")
                }
                    
                    Section {
                        Image(uiImage: imageView/*items.first!.previewImage*/)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.vertical, 3)
                        
                    }
                header: {
                    Text("Media")
                }
                }.frame(height: 600)
    
                    // Add Button
                    Button(action: saveItem, label: {
                        Text("Add")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .background(.red, in: .rect(cornerRadius:10))
                            .contentShape(.rect)
                    })
                
                
                Spacer(minLength: 0)
            }
            .padding(15)
            .onAppear(perform: {
                extractItems(size: size)
            })
        }
    }
    
    func extractItems(size: CGSize) {
        guard items.isEmpty else { return }
                
        DispatchQueue.global(qos: .userInitiated).async {
            for provider in itemProviders {
                
                // Check for image
                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    
                    // Screenshots from iOS
                    provider.loadItem(forTypeIdentifier: UTType.image.identifier) { data, error in
                        if let data, let image = data as? UIImage {
                            DispatchQueue.main.async {
                                self.imageView = image
                                print("test")
                                if let imageData = image.pngData() {
                                    
                            //  could break  //if let image = UIImage(data: imageData) {

                                    if UIImage(data: imageData) != nil {
                                        items.removeAll()
                                        items.append(ImageItem(imageData: imageData, previewImage: imageView))
                                        print("got screenshot image")
                                        return
                                    }
                                }
                            }
                        }
                    }
                    
                    // Images from Photos app and data collection
                    provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { item, error in
                        
                            if let imageData = item {
                                DispatchQueue.main.async {
                                    if let image = UIImage(data: imageData) {
                                        self.imageView = image
                                    }
                                    items.append(ImageItem(imageData: imageData, previewImage: imageView))
                                    print("got data")
                                }
                            }
                        }
                    }
                    
                
            }
        }
    }
    
    func saveItem() {
        do {
            let context = try ModelContext(.init(for: ListItem.self, UserSettings.self))
            context.insert(ListItem(isWant: (type == 0), title: titleTextField, itemImage: items.first?.imageData))
            dismiss()
        } catch {
            print(error.localizedDescription)
            dismiss()
        }
    }
    
    func dismiss() {
        extensionContext?.completeRequest(returningItems: [])
    }
    
    private struct ImageItem: Identifiable {
        let id: UUID = .init()
        var imageData: Data
        var previewImage: UIImage
    }
}
