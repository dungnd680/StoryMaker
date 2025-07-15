//
//  GradientColorModel.swift
//  StoryMaker
//
//  Created by devmacmini on 14/7/25.
//

import Foundation
import SwiftUI

struct GradientColor: Equatable {
    
    enum Angles: Int {
        case leftRight = 0
        case topLeftBottomRight = 45
        case topBottom = 90
        case topRightBottomLeft = 135
    }
    
    var colors: String
    var angle: Int
    var isPremium: Bool
    
    init(_ colors: String, angle: Angles, isPremium: Bool = false) {
        self.colors = colors
        self.angle = angle.rawValue
        self.isPremium = isPremium
    }
    
    var linearGradient: LinearGradient {
        let points = points
        return LinearGradient(colors: uiColors, startPoint: points.start, endPoint: points.end)
    }
    
    var uiColors: [Color] {
        var uicls = [Color]()
        colors.split(separator: "-").forEach { c in
            uicls.append(Color(String(c)))
        }
        return uicls
    }
    
    var points: (start: UnitPoint, end: UnitPoint) {
        switch angle {
        case Angles.leftRight.rawValue:
            return (UnitPoint.leading, UnitPoint.trailing)
        case Angles.topLeftBottomRight.rawValue:
            return (UnitPoint.topLeading, UnitPoint.bottomTrailing)
        case Angles.topBottom.rawValue:
            return (UnitPoint.top, UnitPoint.bottom)
        case Angles.topRightBottomLeft.rawValue:
            return (UnitPoint.topTrailing, UnitPoint.bottomLeading)
        default:
            return (UnitPoint.top, UnitPoint.bottom)
        }
    }
}
