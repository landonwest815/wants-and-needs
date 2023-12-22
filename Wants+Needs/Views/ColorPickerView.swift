//
//  ColorPickerView.swift
//  Wants+Needs
//
//  Created by Landon West on 12/21/23.
//

import SwiftUI

struct ColorPickerView: View {
    
    @Environment(\.dismiss) var dismiss

    @Binding var selectedColor: Color
    let colors: [String] = ["ff0000",
                           "ffa500",
                           "ffff00",
                           "008000",
                           "0000ff",
                           "4b0082",
                           "ee82ee",]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(colors, id: \.self) { color in
                    Button(action: {
                        self.selectedColor = Color(hex: color) ?? .red
                        
                        dismiss()
                    }) {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(hex: color) ?? .red)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: self.selectedColor == Color(hex: color) ?? .red ? 3 : 0)
                            )
                    }
                }
            }
            .padding(30)
        }
        Spacer()
    }
}

#Preview {
    @State var selectedColor = Color.blue
    return ColorPickerView(selectedColor: $selectedColor)
}
