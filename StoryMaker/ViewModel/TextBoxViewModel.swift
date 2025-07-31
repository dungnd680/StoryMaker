//
//  TextBoxViewModel.swift
//  StoryMaker
//
//  Created by devmacmini on 20/6/25.
//

import Foundation
import SwiftUICore

class TextBoxViewModel: ObservableObject {
    @Published var textBoxes: [TextBoxModel] = []
    @Published var activeTextBox: TextBoxModel = .empty()
    @Published var borderTextBoxOffset: CGPoint = .zero
    @Published var activeBoxSize: CGSize = .zero
    
    func addTextBox() {
        let newBox = TextBoxModel()
        newBox.id = UUID().uuidString
        textBoxes.append(newBox)
        activeTextBox = newBox
        borderTextBoxOffset = CGPoint(x: newBox.x, y: newBox.y)
    }
    
    func delete(_ textBox: TextBoxModel) {
        if let index = textBoxes.firstIndex(where: { $0.id == textBox.id }) {
            textBoxes.remove(at: index)
            
            if activeTextBox.id == textBox.id {
                activeTextBox = .empty()
            }
        }
    }
    
    func duplicate(_ textBox: TextBoxModel) {
        let duplicateBox = TextBoxModel(copying: textBox)
        textBoxes.append(duplicateBox)
        activeTextBox = duplicateBox
        borderTextBoxOffset = CGPoint(x: duplicateBox.x, y: duplicateBox.y)
    }
    
    func up(_ textBox: TextBoxModel) {
        guard let index = textBoxes.firstIndex(where: { $0.id == textBox.id }),
                  index < textBoxes.count - 1 else { return }

        textBoxes.swapAt(index, index + 1)
    }

    func down(_ textBox: TextBoxModel) {
        guard let index = textBoxes.firstIndex(where: { $0.id == textBox.id }),
                  index > 0 else { return }

        textBoxes.swapAt(index, index - 1)
    }
}
