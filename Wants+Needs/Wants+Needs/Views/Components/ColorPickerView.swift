//
//  ColorPickerView.swift
//  Wants&Needs
//
//  This view allows the user to select an accent
//  color in a very easy way. All available colors
//  are layed out horizontally, with an indicator
//  showing what's currently chosen.
//

import SwiftUI

struct ColorPickerView: View {
    
    // Allows this view to be closed
    @Environment(\.dismiss) var dismiss

    // Binds with SettingsView to relay the selected color
    @Binding var selectedColor: Color
    
    // Set of colors to choose from
    let colors: [String] = ["ff0000", // Red
                           "ffa500",  // Orange
                           "ffff00",  // Yellow
                           "008000",  // Green
                           "0000ff",  // Blue
                           "4b0082",  // Purple/Violet
                           "ee82ee",] // Pink
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
               
                // Loop through all colors and make them buttons
                ForEach(colors, id: \.self) { color in
                    Button(action: {
                        self.selectedColor = Color(hex: color) ?? .red
                        dismiss()
                    }) {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(hex: color) ?? .black) // If an error arises, the color will default to black
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: self.selectedColor == Color(hex: color) ?? .red ? 3 : 0) // This allows us to see which one was previously selected
                            )
                    }
                }
            }
            .padding(30)
        }
        Spacer() // Push it to the left
    }
}

#Preview {
    @State var selectedColor = Color.blue
    return ColorPickerView(selectedColor: $selectedColor)
}
