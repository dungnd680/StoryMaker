//
//  EditTextModel.swift
//  StoryMaker
//
//  Created by devmacmini on 19/6/25.
//

import SwiftUI

enum TextFill: Equatable {
    case solid(String)
    case gradient(GradientColor)
}

class TextBoxModel: ObservableObject, Identifiable {
    var id: String = ""
    
    @Published var content: String = ""
    @Published var x: CGFloat = 0
    @Published var y: CGFloat = -200
    @Published var sizeText: CGFloat = 100
    @Published var lineHeight: CGFloat = 0
    @Published var letterSpacing: CGFloat = 0
    @Published var fontFamily: String = ""
    @Published var colorText: TextFill = .solid("#FFFFFF")
    @Published var opacity: CGFloat = 100
    
    var shapeStyle: AnyShapeStyle {
        switch colorText {
        case .solid(let hex):
            return AnyShapeStyle(Color(hex))
        case .gradient(let gradient):
            return AnyShapeStyle(gradient.linearGradient)
        }
    }
    
    static func empty() -> TextBoxModel {
        return TextBoxModel()
    }
}

extension TextBoxModel {
    var isEmpty: Bool {
        return id.isEmpty
    }
}
