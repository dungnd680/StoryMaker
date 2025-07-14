//
//  ColorTextView.swift
//  StoryMaker
//
//  Created by devmacmini on 14/7/25.
//

import SwiftUI

struct ColorTextView: View {
    
    @State private var pickerColor: Color = .black
    
    @Binding var colorText: Color
    @Binding var activeColorType: ColorType
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ColorPicker("", selection: $pickerColor, supportsOpacity: true)
                    .labelsHidden()
                    .frame(width: 55, height: 55)
                    .scaleEffect(1.9)
                    .onChange(of: pickerColor) {
                        colorText = pickerColor
                        activeColorType = .solid
                    }
                
                ForEach(Colors.solidColors, id: \.self) { hex in
                    Circle()
                        .foregroundStyle(Color(hex))
                        .frame(width: 55, height: 55)
                        .overlay(
                            hex == "#FFFFFF" ? Circle().stroke(Color.black) : nil
                        )
                        .overlay(
                            Circle()
                                .stroke(colorText == Color(hex) && activeColorType == .solid ? .colorRed : .clear, lineWidth: 2)
                        )
                        .overlay(
                            colorText == Color(hex) && activeColorType == .solid ? Image("Selected Color") : nil
                        )
                        .onTapGesture {
                            colorText = Color(hex)
                            activeColorType = .solid
                        }
                }
            }
            .padding(.horizontal, 26)
            .padding(.bottom, 20)
            .padding(.top, 1)
        }
        .frame(height: 150)
    }
}

//#Preview {
//    ColorTextView(colorText: .constant(.black))
//}
