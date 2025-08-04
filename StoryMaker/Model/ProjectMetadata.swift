//
//  ProjectMetadata.swift
//  StoryMaker
//
//  Created by devmacmini on 4/8/25.
//

import Foundation

struct ProjectMetadata: Codable {
    var textBoxes: [TextBoxCodableModel]
    var lightness: Double
    var saturation: Double
    var blur: Double
    var selectedFilterID: UUID
}
