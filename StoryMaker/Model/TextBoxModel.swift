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

enum TextAlign: String, CaseIterable {
    case left, center, right
}

enum TextCase: String, CaseIterable {
    case normal, uppercase, capitalize, lowercase
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
    @Published var opacityText: CGFloat = 100
    @Published var alignText: TextAlign = .center
    @Published var caseText: TextCase = .normal
    @Published var opacityShadowText: CGFloat = 0
    @Published var blurShadowText: CGFloat = 0
    @Published var xShadowText: CGFloat = -10
    @Published var yShadowText: CGFloat = -10
    @Published var colorShadowText: String = "#000000"
    @Published var paddingBackgroundText: CGFloat = 0
    @Published var cornerBackgroundText: CGFloat = 0
    @Published var opacityBackgroundText: CGFloat = 100
    @Published var colorBackgroundText: String = "#00000000"
    @Published var textSize: CGSize = .zero
    @Published var scale: CGFloat = 1.0
    
    var shapeStyle: AnyShapeStyle {
        switch colorText {
        case .solid(let hex):
            return AnyShapeStyle(Color(hex))
            
        case .gradient(let gradient):
            return AnyShapeStyle(gradient.linearGradient)
        }
    }
    
    var textAlignment: TextAlignment {
        switch alignText {
        case .left:
            return .leading
        case .center:
            return .center
        case .right:
            return .trailing
        }
    }
    
    var formatText: String {
        switch caseText {
        case .normal:
            return content
            
        case .uppercase:
            return content.uppercased()
            
        case .lowercase:
            return content.lowercased()
            
        case .capitalize:
            return content.capitalized
        }
    }
    
    static func empty() -> TextBoxModel {
        return TextBoxModel()
    }
    
    init() {}

    init(copying original: TextBoxModel) {
        self.id = UUID().uuidString
        self.content = original.content
        self.x = original.x + 50
        self.y = original.y + 50
        self.sizeText = original.sizeText
        self.lineHeight = original.lineHeight
        self.letterSpacing = original.letterSpacing
        self.fontFamily = original.fontFamily
        self.colorText = original.colorText
        self.opacityText = original.opacityText
        self.alignText = original.alignText
        self.caseText = original.caseText
        self.opacityShadowText = original.opacityShadowText
        self.blurShadowText = original.blurShadowText
        self.xShadowText = original.xShadowText
        self.yShadowText = original.yShadowText
        self.colorShadowText = original.colorShadowText
        self.paddingBackgroundText = original.paddingBackgroundText
        self.cornerBackgroundText = original.cornerBackgroundText
        self.opacityBackgroundText = original.opacityBackgroundText
        self.colorBackgroundText = original.colorBackgroundText
        self.scale = original.scale
    }
}

extension TextBoxModel {
    var isEmpty: Bool {
        return id.isEmpty
    }
}
