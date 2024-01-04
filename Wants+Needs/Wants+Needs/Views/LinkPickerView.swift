//
//  LinkPickerView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/27/23.
//

import SwiftUI

struct LinkPickerView: View {
    @Binding var enteredLink: String
    @State private var submittedLink: URL?

    var body: some View {
        HStack {
            // TextField for entering the link
            TextField("Enter a webpage", text: $enteredLink)
                .onSubmit {
                    submitLink()
                }
                .keyboardType(.URL)
                .textContentType(.URL)
                .autocapitalization(.none)

            // Display the submitted link as a clickable text, if available
            if let url = submittedLink {
                Link(destination: url) {
                    Image(systemName: "link")
                }
            }
        }
        .onAppear {
            submitLink()
        }
    }

    private func submitLink() {
        // Adjust the enteredLink to include "http://" if it doesn't already contain "http"
        var linkToValidate = enteredLink
        if !linkToValidate.contains("http") {
            linkToValidate = "http://\(linkToValidate)"
        }
        
        // Basic check to see if the URL contains a dot after the protocol
        let hasDotAfterProtocol = linkToValidate.range(of: "http[s]?://[^/]+\\.", options: .regularExpression) != nil

        // Validate and convert the adjusted link to a URL
        if hasDotAfterProtocol, let url = URL(string: linkToValidate), UIApplication.shared.canOpenURL(url) {
            submittedLink = url
        } else {
            // Handle invalid URL
            print("Invalid URL")
            submittedLink = nil
            enteredLink = ""
        }
    }
}

#Preview {
    @State var enteredLink = ""
    return LinkPickerView(enteredLink: $enteredLink)
}
