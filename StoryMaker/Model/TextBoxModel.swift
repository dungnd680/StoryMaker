//
//  EditTextModel.swift
//  StoryMaker
//
//  Created by devmacmini on 19/6/25.
//

import SwiftUI

class TextBoxModel: ObservableObject, Identifiable {
    var id: String = ""
    
    @Published var content: String = ""
    @Published var x: CGFloat = 0
    @Published var y: CGFloat = -200
    @Published var sizeText: CGFloat = 100
    @Published var lineHeight: CGFloat = 0
    @Published var letterSpacing: CGFloat = 0
    @Published var color: String = "#FFFFFF"
    
    static func empty() -> TextBoxModel {
        return TextBoxModel()
    }
}

extension TextBoxModel {
    var isEmpty: Bool {
        return id.isEmpty
    }
}

//    static func empty() -> TextBoxModel {
//        let model = TextBoxModel()
//        model.id = "empty"
//        return model
//    }
