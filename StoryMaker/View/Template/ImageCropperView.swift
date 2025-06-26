//
//  ImageCropperView.swift
//  StoryMaker
//
//  Created by devmacmini on 19/6/25.
//

import SwiftUI
import Mantis

struct ImageCropperView: UIViewControllerRepresentable {
    var image: UIImage
    var onCrop: (UIImage) -> Void
    var onCancel: () -> Void
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> CropViewController {
        var config = Mantis.Config()
        config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 9.0 / 16.0)
        
        let cropViewController = Mantis.cropViewController(image: image, config: config)
        cropViewController.delegate = context.coordinator
        return cropViewController
    }

    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CropViewControllerDelegate {
        let parent: ImageCropperView

        init(_ parent: ImageCropperView) {
            self.parent = parent
        }
        
        func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
            parent.onCrop(cropped)
//            parent.dismiss()
            parent.onCancel()
        }
        
        func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
//            parent.dismiss()
            parent.onCancel()
        }
    }
}

#Preview {
    ImageCropperView(image: .intro1, onCrop: {_ in }, onCancel: {})
}
