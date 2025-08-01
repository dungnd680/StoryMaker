//
//  UIImageTransferable.swift
//  StoryMaker
//
//  Created by devmacmini on 1/8/25.
//

import SwiftUI
import UniformTypeIdentifiers

extension UIImage: @retroactive Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) {
            $0.pngData() ?? Data()
        }
    }
}
