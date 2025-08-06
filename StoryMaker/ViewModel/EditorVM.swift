//
//  ProjectVM.swift
//  StoryMaker
//
//  Created by devmacmini on 5/8/25.
//

import Foundation
import SwiftUI
import PhotosUI

class EditorVM: ObservableObject {
    
    @Published var showImageSelectionOptions: Bool = false
    @Published var showPhotoLibrary: Bool = false
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedImage: UIImage? = nil
    @Published var originalImage: UIImage? = nil
    @Published var showCropper: Bool = false
    @Published var showBackgroundPicker: Bool = false
    @Published var showAdjustBackground: Bool = false
    @Published var filteredThumbnails: [FilterType: UIImage] = [:]
    
    @Published var isEditing: Bool = false
    @Published var showToolText: Bool = false
    @Published var showEditText: Bool = false
    
}
