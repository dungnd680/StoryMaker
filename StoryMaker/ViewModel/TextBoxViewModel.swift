//
//  TextBoxViewModel.swift
//  StoryMaker
//
//  Created by devmacmini on 20/6/25.
//

import Foundation

class TextBoxViewModel: ObservableObject {
    @Published var textBoxes: [TextBoxModel] = []
    
    func addTextBox() {
        let newBox = TextBoxModel(
            text: "",
            position: CGPoint(x: 540, y: 960),
//            scale: 1.0,
//            rotation: .zero,
            isSelected: true,
            isEditing: false
        )
        textBoxes.append(newBox)
    }
}
