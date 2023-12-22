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
    let colors: [Color] = [.red,
                           .orange,
                           .yellow,
                           .green,
                           .blue,
                           .indigo,
                           .purple,]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(colors, id: \.self) { color in
                    Button(action: {
                        self.selectedColor = color
                        
                        dismiss()
                    }) {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 30, height: 30)
                            .foregroundColor(color)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: self.selectedColor == color ? 3 : 0)
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
