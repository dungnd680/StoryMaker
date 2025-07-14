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
    @Published var fontFamily: String = ""
    @Published var colorText: Color = .white
    @Published var gradientText: GradientColor?
//    @Published var colorText: TextColor = .solid(.white)
    
    static func empty() -> TextBoxModel {
        return TextBoxModel()
    }
}

extension TextBoxModel {
    var isEmpty: Bool {
        return id.isEmpty
    }
}

//enum TextColor: Equatable {
//    case solid(Color)
//    case gradient(GradientColor)
//    
//    static func == (lhs: TextColor, rhs: TextColor) -> Bool {
//        switch (lhs, rhs) {
//        case (.solid(let c1), .solid(let c2)):
//            return c1.description == c2.description
//        case (.gradient(let g1), .gradient(let g2)):
//            return g1.colors == g2.colors && g1.angle == g2.angle
//        default:
//            return false
//        }
//    }
//}
