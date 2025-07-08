//
//  TextBoxViewModel.swift
//  StoryMaker
//
//  Created by devmacmini on 20/6/25.
//

import Foundation

class TextBoxViewModel: ObservableObject {
    @Published var textBoxes: [TextBoxModel] = []
    @Published var activeTextBox: TextBoxModel = .empty()
    
    func addTextBox() {
        let newBox = TextBoxModel()
        newBox.id = UUID().uuidString
        textBoxes.append(newBox)
        activeTextBox = newBox
    }
}
