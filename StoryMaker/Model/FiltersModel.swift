//
//  Filters.swift
//  StoryMaker
//
//  Created by devmacmini on 2/7/25.
//

import Foundation
import SwiftUI

struct FiltersModel: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let filterName: String?
}

let filters: [FiltersModel] = [
    FiltersModel(name: "Normal", filterName: nil),
    FiltersModel(name: "Warm", filterName: "CITemperatureAndTint"),
    FiltersModel(name: "Cool", filterName: "CITemperatureAndTint"),
    FiltersModel(name: "Bright", filterName: "CIColorControls"),
    FiltersModel(name: "Dark", filterName: "CIColorControls"),
    FiltersModel(name: "Saturated", filterName: "CIColorControls"),
    FiltersModel(name: "Desaturated", filterName: "CIColorControls"),
    FiltersModel(name: "Fade", filterName: "CIPhotoEffectFade"),
    FiltersModel(name: "Sepia", filterName: "CISepiaTone"),
    FiltersModel(name: "Process", filterName: "CIPhotoEffectProcess"),
    FiltersModel(name: "Transfer", filterName: "CIPhotoEffectTransfer"),
    FiltersModel(name: "Noir", filterName: "CIPhotoEffectNoir"),
    FiltersModel(name: "Chrome", filterName: "CIPhotoEffectChrome"),
    FiltersModel(name: "Instant", filterName: "CIPhotoEffectInstant"),
    FiltersModel(name: "Mono", filterName: "CIPhotoEffectMono"),
    FiltersModel(name: "Tonal", filterName: "CIPhotoEffectTonal"),
    FiltersModel(name: "Invert", filterName: "CIColorInvert")
]

func applyFilter(_ filter: FiltersModel, to image: UIImage) -> UIImage {
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
