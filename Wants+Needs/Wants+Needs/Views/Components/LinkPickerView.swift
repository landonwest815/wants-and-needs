//
//  LinkPickerView.swift
//  Wants&Needs
//
//  This view allows us to simply enter a string input and
//  have it check if it's a valid URL. If so, a Link
//  component is provided.
//

import SwiftUI

struct LinkPickerView: View {
    // Binds with ItemFormView to allow the string to be saved to Data
    @Binding var enteredLink: String
    // This is updated if the link is valid using SubmitLink() below
    @State private var submittedLink: URL?
    // This allows us to make use of a "done" button on the keyboard
    @FocusState var isInputActive: Bool

    var body: some View {
        HStack {
            TextField("Enter a webpage", text: $enteredLink)
                .onSubmit {
                    submitLink()
                }
                .keyboardType(.URL)
                .textContentType(.URL)
                .autocapitalization(.none)

            // Display a link button if valid
            if let url = submittedLink {
                Link(destination: url) {
                    Image(systemName: "link")
                }
            }
        }
        // For exiting links via Data
        .onAppear {
            submitLink()
        }
    }

    /* This private helper method will read the entered string upon submission and check if it is valid. It will also take care of appending any web address related protocols. */
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
