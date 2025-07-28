//
//  BackgroundModel.swift
//  StoryMaker
//
//  Created by devmacmini on 24/6/25.
//

import Foundation

struct BackgroundModel: Codable {
    let config: Config
    let data: [DataBackground]
}

struct Config: Codable {
    let category: [CategoryElement]
}

struct CategoryElement: Codable, Equatable {
    let id: CategoryEnum
    let name: String
}

enum CategoryEnum: String, Codable {
    case animals = "animals"
    case bw = "bw"
    case car = "car"
    case cartoon = "cartoon"
    case color = "color"
    case device = "device"
    case fantasy = "fantasy"
    case flower = "flower"
    case holiday = "holiday"
    case light = "light"
    case love = "love"
    case mood = "mood"
    case music = "music"
    case nature = "nature"
    case space = "space"
    case sport = "sport"
    case travel = "travel"
}

struct DataBackground: Codable {
    let category: CategoryEnum
    let thumb, background: String
}

struct ConfigOnlyResponse: Decodable {
    let config: Config
}
