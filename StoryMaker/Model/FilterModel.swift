//
//  Filters.swift
//  StoryMaker
//
//  Created by devmacmini on 2/7/25.
//

import Foundation
import SwiftUI

struct FilterModel: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let filterName: String?
}

let filters: [FilterModel] = [
    FilterModel(name: "Normal", filterName: nil),
    FilterModel(name: "Warm", filterName: "CITemperatureAndTint"),
    FilterModel(name: "Cool", filterName: "CITemperatureAndTint"),
    FilterModel(name: "Bright", filterName: "CIColorControls"),
    FilterModel(name: "Dark", filterName: "CIColorControls"),
    FilterModel(name: "Saturated", filterName: "CIColorControls"),
    FilterModel(name: "Desaturated", filterName: "CIColorControls"),
    FilterModel(name: "Fade", filterName: "CIPhotoEffectFade"),
    FilterModel(name: "Sepia", filterName: "CISepiaTone"),
    FilterModel(name: "Process", filterName: "CIPhotoEffectProcess"),
    FilterModel(name: "Transfer", filterName: "CIPhotoEffectTransfer"),
    FilterModel(name: "Noir", filterName: "CIPhotoEffectNoir"),
    FilterModel(name: "Chrome", filterName: "CIPhotoEffectChrome"),
    FilterModel(name: "Instant", filterName: "CIPhotoEffectInstant"),
    FilterModel(name: "Mono", filterName: "CIPhotoEffectMono"),
    FilterModel(name: "Tonal", filterName: "CIPhotoEffectTonal"),
    FilterModel(name: "Invert", filterName: "CIColorInvert")
]

func applyFilter(_ filter: FilterModel, to image: UIImage) -> UIImage {
    guard let name = filter.filterName,
          let ciImage = CIImage(image: image),
          let ciFilter = CIFilter(name: name)
    else {
        return image
    }

    ciFilter.setValue(ciImage, forKey: kCIInputImageKey)

    switch filter.name {
    case "CISepiaTone":
        ciFilter.setValue(0.8, forKey: kCIInputIntensityKey)

    case "Warm":
        ciFilter.setValue(CIVector(x: 6500, y: 0), forKey: "inputNeutral")
        ciFilter.setValue(CIVector(x: 4000, y: 0), forKey: "inputTargetNeutral")

    case "Cool":
        ciFilter.setValue(CIVector(x: 6500, y: 0), forKey: "inputNeutral")
        ciFilter.setValue(CIVector(x: 8000, y: 0), forKey: "inputTargetNeutral")

    case "Bright":
        ciFilter.setValue(0.2, forKey: kCIInputBrightnessKey)

    case "Dark":
        ciFilter.setValue(-0.2, forKey: kCIInputBrightnessKey)

    case "Saturated":
        ciFilter.setValue(2.0, forKey: kCIInputSaturationKey)

    case "Desaturated":
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
