//
//  ColorExtension.swift
//  StoryMaker
//
//  Created by devmacmini on 14/7/25.
//

import Foundation
import SwiftUI

extension Color {
    init(_ hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: Double

        if hex.count == 6 {
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
            self.init(red: r, green: g, blue: b)
        } else {
            self = .clear
        }
    }
}
