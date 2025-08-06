//
//  Filters.swift
//  StoryMaker
//
//  Created by devmacmini on 2/7/25.
//

//import Foundation
//import SwiftUI
//
//struct FilterModel: Identifiable, Equatable, Codable {
//    let id: String
//    let name: String
//    let filterName: String?
//}
//
//let filters: [FilterModel] = [
//    FilterModel(id: "normal", name: "Normal", filterName: nil),
//    FilterModel(id: "warm", name: "Warm", filterName: "CITemperatureAndTint"),
//    FilterModel(id: "cool", name: "Cool", filterName: "CITemperatureAndTint"),
//    FilterModel(id: "bright", name: "Bright", filterName: "CIColorControls"),
//    FilterModel(id: "dark", name: "Dark", filterName: "CIColorControls"),
//    FilterModel(id: "saturated", name: "Saturated", filterName: "CIColorControls"),
//    FilterModel(id: "desaturated", name: "Desaturated", filterName: "CIColorControls"),
//    FilterModel(id: "fade", name: "Fade", filterName: "CIPhotoEffectFade"),
//    FilterModel(id: "sepia", name: "Sepia", filterName: "CISepiaTone"),
//    FilterModel(id: "process", name: "Process", filterName: "CIPhotoEffectProcess"),
//    FilterModel(id: "transfer", name: "Transfer", filterName: "CIPhotoEffectTransfer"),
//    FilterModel(id: "noir", name: "Noir", filterName: "CIPhotoEffectNoir"),
//    FilterModel(id: "chrome", name: "Chrome", filterName: "CIPhotoEffectChrome"),
//    FilterModel(id: "instant", name: "Instant", filterName: "CIPhotoEffectInstant"),
//    FilterModel(id: "mono", name: "Mono", filterName: "CIPhotoEffectMono"),
//    FilterModel(id: "tonal", name: "Tonal", filterName: "CIPhotoEffectTonal"),
//    FilterModel(id: "invert", name: "Invert", filterName: "CIColorInvert")
//]

//func applyFilter(_ filter: FilterModel, to image: UIImage) -> UIImage {
//    guard let name = filter.filterName,
//          let ciImage = CIImage(image: image),
//          let ciFilter = CIFilter(name: name)
//    else {
//        return image
//    }
//
//    ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
//
//    switch filter.name {
//    case "CISepiaTone":
//        ciFilter.setValue(0.8, forKey: kCIInputIntensityKey)
//
//    case "Warm":
//        ciFilter.setValue(CIVector(x: 6500, y: 0), forKey: "inputNeutral")
//        ciFilter.setValue(CIVector(x: 4000, y: 0), forKey: "inputTargetNeutral")
//
//    case "Cool":
//        ciFilter.setValue(CIVector(x: 6500, y: 0), forKey: "inputNeutral")
//        ciFilter.setValue(CIVector(x: 8000, y: 0), forKey: "inputTargetNeutral")
//
//    case "Bright":
//        ciFilter.setValue(0.2, forKey: kCIInputBrightnessKey)
//
//    case "Dark":
//        ciFilter.setValue(-0.2, forKey: kCIInputBrightnessKey)
//
//    case "Saturated":
//        ciFilter.setValue(2.0, forKey: kCIInputSaturationKey)
//
//    case "Desaturated":
//        ciFilter.setValue(0.3, forKey: kCIInputSaturationKey)
//
//    default:
//        break
//    }
//
//    let context = CIContext()
//    guard let output = ciFilter.outputImage,
//          let cgImage = context.createCGImage(output, from: output.extent)
//    else {
//        return image
//    }
//
//    return UIImage(cgImage: cgImage)
//}
