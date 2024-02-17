//
//  ShareViewController.swift
//  Share
//
//  Created by Landon West on 2/15/24.
//

import UIKit
import Social
import SwiftUI

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        isModalInPresentation = true
        
        let hostingView = UIHostingController(rootView: ShareView())
        hostingView.view.frame = view.frame
        view.addSubview(hostingView.view)
    }
}

fileprivate struct ShareView: View {
    var extensionContext: NSExtensionContext?
    var body: some View {
        VStack(spacing: 15) {
            Text("Add to ...")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button("Cancel", action: dismiss)
                    .tint(.red)
                }
            
            Spacer(minLength: 0)
        }
        .padding(15)
    }
    
    func dismiss() {
        self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
