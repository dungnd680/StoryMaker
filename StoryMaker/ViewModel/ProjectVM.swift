//
//  ProjectsViewModel.swift
//  StoryMaker
//
//  Created by devmacmini on 4/8/25.
//

import Foundation
import SwiftUI

class ProjectVM: ObservableObject {
    
    @Published var showEditor: Bool = false
    @Published var showSubscription: Bool = false
    
//    @Published var savedImageURLs: [URL] = []
//    
//    init() {
//        loadSavedImages()
//    }
//
//    func loadSavedImages() {
//        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let files = try? FileManager.default.contentsOfDirectory(at: documents, includingPropertiesForKeys: nil)
//        savedImageURLs = files?.filter { $0.pathExtension == "jpg" } ?? []
//    }
}

//extension ProjectViewModel {
//    func saveProjectData(
//        image: UIImage,
//        name: String,
//        textBoxes: [TextBox],
//        lightness: Double,
//        saturation: Double,
//        blur: Double,
//        selectedFilter: FilterModel,
//        completion: (() -> Void)? = nil
//    ) {
//        let metadata = ProjectMetadata(
//            textBoxes: textBoxes.map { $0.toCodable() },
//            lightness: lightness,
//            saturation: saturation,
//            blur: blur,
//            selectedFilterID: selectedFilter.id
//        )
//
//        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let imageURL = documents.appendingPathComponent("\(name).jpg")
//        let jsonURL = documents.appendingPathComponent("\(name).json")
//
//        if let data = image.jpegData(compressionQuality: 1.0) {
//            try? data.write(to: imageURL)
//        }
//
//        do {
//            let encoded = try JSONEncoder().encode(metadata)
//            try encoded.write(to: jsonURL)
//        } catch {
//            print("Failed to save metadata: \(error)")
//        }
//    }
//
//    func loadProjectData(name: String) -> ProjectMetadata? {
//        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let jsonURL = documents.appendingPathComponent("\(name).json")
//        guard FileManager.default.fileExists(atPath: jsonURL.path) else { return nil }
//
//        do {
//            let data = try Data(contentsOf: jsonURL)
//            let metadata = try JSONDecoder().decode(ProjectMetadata.self, from: data)
//            return metadata
//        } catch {
//            print("Failed to load metadata: \(error)")
//            return nil
//        }
//    }
//    
//    func loadAllProjects() -> [ProjectPreview] {
//        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let fileURLs = (try? FileManager.default.contentsOfDirectory(at: documents, includingPropertiesForKeys: [.contentModificationDateKey])) ?? []
//
//        var previews: [ProjectPreview] = []
//        let grouped = Dictionary(grouping: fileURLs, by: { $0.deletingPathExtension().lastPathComponent.replacingOccurrences(of: "_thumb", with: "") })
//
//        for (name, urls) in grouped {
//            guard let imageURL = urls.first(where: { $0.lastPathComponent == "\(name).jpg" }),
//                  let thumbURL = urls.first(where: { $0.lastPathComponent == "\(name)_thumb.jpg" }),
//                  let date = try? imageURL.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate else {
//                continue
//            }
//
//            previews.append(ProjectPreview(
//                name: name,
//                imageURL: imageURL,
//                thumbURL: thumbURL,
//                lastModified: date
//            ))
//        }
//
//        return previews.sorted(by: { $0.lastModified > $1.lastModified })
//    }
//    
//    func deleteProject(named name: String) {
//        let fileManager = FileManager.default
//        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        
//        let imageURL = documents.appendingPathComponent("\(name).jpg")
//        let jsonURL = documents.appendingPathComponent("\(name).json")
//        let thumbURL = documents.appendingPathComponent("\(name)_thumb.jpg")
//        
//        [imageURL, jsonURL, thumbURL].forEach { url in
//            if fileManager.fileExists(atPath: url.path) {
//                do {
//                    try fileManager.removeItem(at: url)
//                } catch {
//                    print("Failed to delete \(url.lastPathComponent): \(error)")
//                }
//            }
//        }
//    }
//}
