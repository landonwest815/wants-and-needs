//
//  ShareViewController.swift
//  Sharing
//
//  Created by Landon West on 12/27/23.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure access to extensionItem and itemProvider
        guard
            let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first else {
            close()
            return
        }
        
        // Check type identifier
        let textDataType = UTType.plainText.identifier
        if itemProvider.hasItemConformingToTypeIdentifier(textDataType) {

            // Load the item from itemProvider
            itemProvider.loadItem(forTypeIdentifier: textDataType , options: nil) { (providedText, error) in
                if error != nil {
                      self.close()
                      return
                  }
                
                if let text = providedText as? String {
                    DispatchQueue.main.async {
                        // host the SwiftU view
                        let contentView = UIHostingController(rootView: ShareExtensionView(text: text))
                        self.addChild(contentView)
                        self.view.addSubview(contentView.view)
                        
                        // set up constraints
                        contentView.view.translatesAutoresizingMaskIntoConstraints = false
                        contentView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                        contentView.view.bottomAnchor.constraint (equalTo: self.view.bottomAnchor).isActive = true
                        contentView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                        contentView.view.rightAnchor.constraint (equalTo: self.view.rightAnchor).isActive = true
                    }
                } else {
                    self.close()
                    return
                }
                
            }

        } else {
            close()
            return
        }
       
        NotificationCenter.default.addObserver(forName: NSNotification.Name("close"), object: nil, queue: nil) { _ in
            DispatchQueue.main.async {
                self.close()
            }
        }
    }
    
    // Close the Share Extension
    func close() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
