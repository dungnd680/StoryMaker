//
//  FontItemView.swift
//  StoryMaker
//
//  Created by devmacmini on 11/7/25.
//

import SwiftUI

struct FontItemView: View {
    
    let content: String
    let font: CFont
    let isSelected: Bool

    var body: some View {
        let displayFontText = content.contains(" ")
            ? content.components(separatedBy: " ").first ?? ""
            : String(content.prefix(12))

        Text(displayFontText)
            .padding(.horizontal, 6)
            .foregroundStyle(Color.colorDarkGray)
            .font(.custom(font.iosFamily, size: 16))
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .background(isSelected ? .white : .gray.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke((isSelected && !font.iosFamily.isEmpty) ? .colorRed : .clear, lineWidth: 2)
            )
            .cornerRadius(6)
            .overlay(
                font.isPremium ? Image("Premium") : nil,
                alignment: .topTrailing
            )
    }
}

#Preview {
    FontItemView(
        content: "Nguyễn Đình Dũng",
        font: CFont.fonts[1],
        isSelected: true
    )
}
