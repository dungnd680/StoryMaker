//
//  ResizeImageExtension.swift
//  StoryMaker
//
//  Created by devmacmini on 2/7/25.
//

import SwiftUI

extension UIImage {
    func resizedMaintainingAspectRatio(toMaxSize maxSize: CGSize) -> UIImage {
        let aspectWidth = maxSize.width / self.size.width
        let aspectHeight = maxSize.height / self.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)

        let newSize = CGSize(width: self.size.width * aspectRatio,
                             height: self.size.height * aspectRatio)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
