//
//  ShareViewController.swift
//  Share
//
//  Created by Landon West on 2/15/24.
//

import UIKit
import Social
import SwiftUI
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
    @State private var imageView: UIImage = .checkmark
    
    var body: some View {
        
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 15) {
                Text("Add to ...")
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
                }
                
                
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
                let _ = provider.loadDataRepresentation(for: .image) { data, error in
                    if let data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            items.append(.init(imageData: data, previewImage: image))
                        }
                    }
                }
            }
        }
        
        if let extensionItems = self.extensionContext?.inputItems as? [NSExtensionItem]  {
              let attachments     = extensionItems.first?.attachments ?? []
              let imageType       = UTType.image.identifier
              
              for provider in attachments {
                 if provider.hasItemConformingToTypeIdentifier(imageType) {
                    print("It is an image")

                    // this seems only to handle media from photos
                     provider.loadItem(forTypeIdentifier: UTType.image.identifier) { item, error in
                                                  if let image = item as? UIImage {
                                                      DispatchQueue.main.async {
                                                          print("It is an image")
                                                          self.imageView = image
                                                      }
                                                      return
                                                  }

                                              }
                 }
              }
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
