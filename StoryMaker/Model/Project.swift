//
//  Project.swift
//  StoryMaker
//
//  Created by devmacmini on 5/8/25.
//

import Foundation

class Project: ObservableObject {
    
    @Published var idProject: String = UUID().uuidString
    @Published var textBoxes: [TextBox] = []
    @Published var activeTextBox: TextBox = .empty()
//    @Published var filter: Filter = Filter()
    @Published var borderTextBoxOffset: CGPoint = .zero
    @Published var activeBoxSize: CGSize = .zero
    
    func newTextBox() -> TextBox {
        let tb = TextBox()
        return tb
    }
    
    func addTextBox() {
        let newBox = TextBox()
        newBox.id = UUID().uuidString
        textBoxes.append(newBox)
        activeTextBox = newBox
        borderTextBoxOffset = CGPoint(x: newBox.x, y: newBox.y)
    }
    
    func delete(_ textBox: TextBox) {
        if let index = textBoxes.firstIndex(where: { $0.id == textBox.id }) {
            textBoxes.remove(at: index)
            
            if activeTextBox.id == textBox.id {
                activeTextBox = .empty()
            }
        }
    }
    
    func duplicate(_ textBox: TextBox) {
        let duplicateBox = TextBox(copying: textBox)
        textBoxes.append(duplicateBox)
        activeTextBox = duplicateBox
        borderTextBoxOffset = CGPoint(x: duplicateBox.x, y: duplicateBox.y)
    }
    
    func up(_ textBox: TextBox) {
        guard let index = textBoxes.firstIndex(where: { $0.id == textBox.id }),
                  index < textBoxes.count - 1 else { return }

        textBoxes.swapAt(index, index + 1)
    }

    func down(_ textBox: TextBox) {
        guard let index = textBoxes.firstIndex(where: { $0.id == textBox.id }),
                  index > 0 else { return }

        textBoxes.swapAt(index, index - 1)
    }
}
