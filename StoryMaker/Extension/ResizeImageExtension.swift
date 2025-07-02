//
//  ResizeImageExtension.swift
//  StoryMaker
//
//  Created by devmacmini on 2/7/25.
//

import SwiftUI

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

