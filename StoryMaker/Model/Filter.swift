//
//  Filter.swift
//  StoryMaker
//
//  Created by devmacmini on 5/8/25.
//

import SwiftUI

enum FilterType {
    case normal, warm, cool, bright, dark, saturated, desaturated, fade, sepia, process, transfer, noir, chrome, instant, mono, tonal, invert
}

class Filter: ObservableObject {
    
    @Published var type: FilterType = .normal
    
    static let filters: [(id: FilterType, name: String, filterName: String)] = [
        (.normal, "Normal", ""),
        (.warm, "Warm", "CITemperatureAndTint"),
        (.cool, "Cool", "CITemperatureAndTint"),
        (.bright, "Bright", "CIColorControls"),
        (.dark, "Dark", "CIColorControls"),
        (.saturated, "Saturated", "CIColorControls"),
        (.desaturated, "Desaturated", "CIColorControls"),
        (.fade, "Fade", "CIPhotoEffectFade"),
        (.sepia, "Sepia", "CISepiaTone"),
        (.process, "Process", "CIPhotoEffectProcess"),
        (.transfer, "Transfer", "CIPhotoEffectTransfer"),
        (.noir, "Noir", "CIPhotoEffectNoir"),
        (.chrome, "Chrome", "CIPhotoEffectChrome"),
        (.instant, "Instant", "CIPhotoEffectInstant"),
        (.mono, "Mono", "CIPhotoEffectMono"),
        (.tonal, "Tonal", "CIPhotoEffectTonal"),
        (.invert, "Invert", "CIColorInvert")
    ]
    
    static func apply(_ type: FilterType, to image: UIImage) -> UIImage {
        guard let name = filters.first(where: { $0.id == type })?.filterName,
              !name.isEmpty,
              let ciImage = CIImage(image: image),
              let ciFilter = CIFilter(name: name)
        else {
            return image
        }

        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)

        switch type {
        case .sepia:
            ciFilter.setValue(0.8, forKey: kCIInputIntensityKey)

        case .warm:
            ciFilter.setValue(CIVector(x: 6500, y: 0), forKey: "inputNeutral")
            ciFilter.setValue(CIVector(x: 4000, y: 0), forKey: "inputTargetNeutral")

        case .cool:
            ciFilter.setValue(CIVector(x: 6500, y: 0), forKey: "inputNeutral")
            ciFilter.setValue(CIVector(x: 8000, y: 0), forKey: "inputTargetNeutral")

        case .bright:
            ciFilter.setValue(0.2, forKey: kCIInputBrightnessKey)

        case .dark:
            ciFilter.setValue(-0.2, forKey: kCIInputBrightnessKey)

        case .saturated:
            ciFilter.setValue(2.0, forKey: kCIInputSaturationKey)

        case .desaturated:
            ciFilter.setValue(0.3, forKey: kCIInputSaturationKey)

        default:
            break
        }

        let context = CIContext()
        guard let output = ciFilter.outputImage,
              let cgImage = context.createCGImage(output, from: output.extent)
        else {
            return image
        }

        return UIImage(cgImage: cgImage)
    }
}
