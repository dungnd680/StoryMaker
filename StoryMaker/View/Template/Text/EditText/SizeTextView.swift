//
//  SizeTextView.swift
//  StoryMaker
//
//  Created by devmacmini on 10/7/25.
//

import SwiftUI

struct SizeTextView: View {
    @Binding var sizeText: CGFloat
    @Binding var lineHeight: CGFloat
    @Binding var letterSpacing: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer()
            
            SlidersView(value: $sizeText, label: "Size", range: 30...500)
            SlidersView(value: $lineHeight, label: "Line Height", range: 0...100)
            SlidersView(value: $letterSpacing, label: "Letter Spacing", range: 0...100)
        }
        .padding(.leading, 26)
        .padding(.trailing)
        .padding(.bottom, 48)
        .frame(height: 220)
    }
}

#Preview {
    SizeTextView(
        sizeText: .constant(100),
        lineHeight: .constant(0),
        letterSpacing: .constant(0)
    )
}
