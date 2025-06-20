//
//  EditTextView.swift
//  StoryMaker
//
//  Created by devmacmini on 19/6/25.
//

import SwiftUI

struct TextBoxView: View {
    @Binding var box: TextBoxModel
    @Binding var text: String
    @Environment(\._isExporting) private var isExporting
    @GestureState private var dragOffset: CGSize = .zero
    
    var body: some View {
        Group {
            if isExporting {
                Text(text)
            } else {
                ZStack(alignment: .center) {
                    if box.text.isEmpty {
                        Text("Text...")
                            .foregroundColor(.gray)
                    }
                    
                    TextField("", text: $box.text)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .background(Color.clear)
                }
            }
        }
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 1))
        .fixedSize()
        .position(x: box.position.x + dragOffset.width,
                  y: box.position.y + dragOffset.height)
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    box.position.x += value.translation.width
                    box.position.y += value.translation.height
                }
        )
    }
}

//#Preview {
//    TextBoxView()
//}
