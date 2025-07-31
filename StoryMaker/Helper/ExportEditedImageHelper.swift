//
//  ImageSaver.swift
//  StoryMaker
//
//  Created by devmacmini on 16/6/25.
//

import Foundation
import SwiftUI
import Photos

struct ExportEditedImageHelper {
    @MainActor
    static func exportEditedImage(from view: some View, onComplete: @escaping (Bool, String, UIImage?) -> Void) {
        let staticView = view.environment(\.isExporting, true)
        let renderer = ImageRenderer(content: staticView)
        let baseSize = CGSize(width: 1080, height: 1920)

        renderer.proposedSize = .init(baseSize)
        renderer.scale = 1.0

        guard let editorImage = renderer.uiImage else {
            onComplete(false, "Cannot create image.", nil)
            return
        }

        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)

        func save(_ image: UIImage) {
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { success, error in
                DispatchQueue.main.async {
                    if let error = error {
                        onComplete(false, "Error save: \(error.localizedDescription)", nil)
                    } else {
                        onComplete(true, "Saved successfully.", image)
                    }
                }
            }
        }

        switch status {
        case .authorized, .limited:
            save(editorImage)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    save(editorImage)
                } else {
                    DispatchQueue.main.async {
                        onComplete(false, "You have denied permission to save the image.", nil)
                    }
                }
            }
        default:
            onComplete(false, "No permission to save image. Please check Settings.", nil)
        }
    }
}

private struct IsExportingKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isExporting: Bool {
        get {
            self[IsExportingKey.self]
        } set {
            self[IsExportingKey.self] = newValue
        }
    }
}
