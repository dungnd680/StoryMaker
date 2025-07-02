//
//  EditTextModel.swift
//  StoryMaker
//
//  Created by devmacmini on 19/6/25.
//

import SwiftUI

struct TextBoxModel: Identifiable {
    var id: UUID = UUID()
    var text: String
    var position: CGPoint
    var scale: CGFloat
    var rotation: Angle
    var isSelected: Bool
}
