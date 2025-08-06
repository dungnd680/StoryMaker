//
//  TemplateView.swift
//  StoryMaker
//
//  Created by devmacmini on 6/6/25.
//

import SwiftUI
import PhotosUI
import Mantis

//struct TemplateInputData {
//    var name: String
//    var image: UIImage
//    var metadata: ProjectMetadata?
//}

struct EditorView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var editorVM: EditorVM = EditorVM()
    @StateObject var filter: Filter = Filter()
    @StateObject var textBox: TextBox = TextBox()
    
    @State private var lightness: Double = 0
    @State private var saturation: Double = 0
    @State private var blur: Double = 0
    
    @FocusState private var isTextFieldFocused: Bool
    
//    @State private var selectedTab: EditTextTab = .size
//    @State private var triggerScroll: Bool = false
//    @State private var exportedImage: UIImage? = nil
//    @State private var showExportDone: Bool = false
//    @State private var currentProjectName: String? = nil
//    @State private var didLoadMetadata = false
    
//    @StateObject private var textBoxViewModel = TextBoxViewModel()
    
//    @StateObject var textBox: TextBox = TextBox()
//    @StateObject private var projectViewModel = ProjectViewModel()
    
//    @Binding var showSubscription: Bool
//    @Binding var projects: [ProjectPreview]
    
//    var input: TemplateInputData?
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
//                        if let selectedImage = selectedImage {
//                            let name = currentProjectName ?? UUID().uuidString
//                            
//                            projectViewModel.saveProjectData(
//                                image: selectedImage,
//                                name: name,
//                                textBoxes: textBoxViewModel.textBoxes,
//                                lightness: lightness,
//                                saturation: saturation,
//                                blur: blur,
//                                selectedFilter: selectedFilter
//                            )
//                            
//                            let editorView = EditorImageView(
//                                textBoxViewModel: textBoxViewModel,
//                                lightness: $lightness,
//                                saturation: $saturation,
//                                blur: $blur,
//                                selectedFilter: $selectedFilter,
//                                showToolText: $showToolText,
//                                isEditing: $isEditing,
//                                showEditText: $showEditText,
//                                showAdjustBackground: $showAdjustBackground,
//                                image: selectedImage,
//                                isTextFieldFocused: $isTextFieldFocused
//                            )
//                            
//                            ExportEditedImageHelper.exportEditedImage(from: editorView) { _, _, image in
//                                if let thumb = image?.resizedMaintainingAspectRatio(toMaxSize: CGSize(width: 300, height: 300)),
//                                   let data = thumb.jpegData(compressionQuality: 0.8) {
//                                    let url = FileManager.default
//                                        .urls(for: .documentDirectory, in: .userDomainMask)[0]
//                                        .appendingPathComponent("\(name)_thumb.jpg")
//                                    try? data.write(to: url)
//                                    
//                                    projects = projectViewModel.loadAllProjects()
//                                    dismiss()
//                                }
//                            }
//                        }
//                        
//                        if selectedImage == nil {
//                            dismiss()
//                        }
                        dismiss()
                    } label: {
                        Image("Back")
                    }
                    
                    Spacer()
                    
                    Button {
                        exportImage()
                    } label: {
                        Image("Export")
                            .opacity(editorVM.selectedImage == nil ? 0.5 : 1.0)
                    }
                    .disabled(editorVM.selectedImage == nil)
                }
                .padding(.horizontal)
                .padding(.top, 4)
                .padding(.bottom, 2)
                
                ZStack {
                    if let image = editorVM.selectedImage {
                        ImageView(
                            image: image,
                            editorVM: editorVM,
                            filter: filter,
                            lightness: $lightness,
                            saturation: $saturation,
                            blur: $blur
                        )
                    } else {
                        Color.customLightGray
                        
                        VStack {
                            Button {
                                editorVM.showImageSelectionOptions = true
                            } label: {
                                Image("Add Background")
                            }
                            
                            Text("Tap To Add Background")
                                .font(.system(size: 16))
                                .foregroundStyle(.black)
                        }
                        .confirmationDialog("Select Background", isPresented: $editorVM.showImageSelectionOptions) {
                            Button("Choose from Library") {
                                editorVM.showPhotoLibrary.toggle()
                            }
                            
                            Button("Other") {
                                editorVM.showBackgroundPicker = true
                            }
                        }
                        .photosPicker(isPresented: $editorVM.showPhotoLibrary, selection: $editorVM.selectedItem)
                        .onChange(of: editorVM.selectedItem) {
                            Task {
                                if let data = try? await editorVM.selectedItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    editorVM.originalImage = uiImage
                                    editorVM.showCropper = true
                                    editorVM.selectedItem = nil
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button {
//                        textBox.newTextBox()
//                        textBoxViewModel.addTextBox()
                    } label: {
                        VStack {
                            Image("Add Text")
                            Text("Add Text")
                                .font(.system(size: 12))
                                .foregroundStyle(.customDarkGray)
                        }
                        .opacity(editorVM.selectedImage == nil ? 0.5 : 1.0)
                    }
                    .disabled(editorVM.selectedImage == nil)
                    
                    Spacer()
                    Spacer()
                    
                    Button {
                        editorVM.showAdjustBackground = true
                    } label: {
                        VStack {
                            Image("Background")
                            Text("Background")
                                .font(.system(size: 12))
                                .foregroundStyle(.customDarkGray)
                        }
                        .opacity(editorVM.selectedImage == nil ? 0.5 : 1.0)
                    }
                    .disabled(editorVM.selectedImage == nil)
                    
                    Spacer()
                }
            }
            
//            ToolTextView(
//                isVisible: $showToolText,
//                selectedTab: $selectedTab,
//                showEditTextView: $showEditText
//            )
//            
//            EditTextView(
//                textBoxViewModel: textBoxViewModel,
//                textBoxModel: textBoxModel,
//                isVisible: $showEditText,
//                isEditing: $isEditing,
//                selectedTab: $selectedTab,
//                showSubscription: $showSubscription,
//                showToolText: $showToolText,
//                triggerScroll: $triggerScroll,
//                isTextFieldFocused: $isTextFieldFocused
//            )
            
            AdjustBackgroundView(
                editorVM: editorVM,
                filter: filter,
                lightness: $lightness,
                saturation: $saturation,
                blur: $blur,
                isVisible: $editorVM.showAdjustBackground) {
                    editorVM.showAdjustBackground = false
                }
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.keyboard)
//        .onAppear {
//            if let input = input {
//                selectedImage = input.image
//                currentProjectName = input.name
//
//                if let meta = input.metadata {
//                    textBoxViewModel.textBoxes = meta.textBoxes.map { TextBoxModel.fromCodable($0) }
//                    lightness = meta.lightness
//                    saturation = meta.saturation
//                    blur = meta.blur
//                    selectedFilter = filters.first(where: { $0.id == meta.selectedFilterID }) ?? filters[0]
//                    
//                    didLoadMetadata = true
//                    
//                    if let image = selectedImage {
//                        filteredThumbnails = [:]
//                        let thumbnail = image.resizedMaintainingAspectRatio(toMaxSize: CGSize(width: 60, height: 60))
//                        for filter in filters {
//                            DispatchQueue.global(qos: .userInitiated).async {
//                                let result = applyFilter(filter, to: thumbnail)
//                                DispatchQueue.main.async {
//                                    filteredThumbnails[filter.id] = result
//                                }
//                            }
//                        }
//                    }
//                    
//                    print("selectedFilterID: \(meta.selectedFilterID)")
//                    print("filters: \(filters.map(\.id))")
//                }
//            }
//        }
        .onChange(of: editorVM.selectedImage) {
            guard let image = editorVM.selectedImage else { return }
                editorVM.filteredThumbnails = [:]
                let thumbnail = image.resizedMaintainingAspectRatio(toMaxSize: CGSize(width: 60, height: 60))
                for filterData in Filter.filters {
                    DispatchQueue.global(qos: .userInitiated).async {
                        let result = Filter.apply(filterData.id, to: thumbnail)
                        DispatchQueue.main.async {
                            editorVM.filteredThumbnails[filterData.id] = result
                        }
                    }
                }
//            guard let image = selectedImage, !didLoadMetadata else { return }
//            
//            textBoxViewModel.textBoxes = []
//            showAdjustBackground = false
//            lightness = 0
//            saturation = 0
//            blur = 0
//            selectedFilter = filters[0]
//            
//            filteredThumbnails = [:]
//            let thumbnail = image.resizedMaintainingAspectRatio(toMaxSize: CGSize(width: 60, height: 60))
//            for filter in filters {
//                DispatchQueue.global(qos: .userInitiated).async {
//                    let result = applyFilter(filter, to: thumbnail)
//                    DispatchQueue.main.async {
//                        filteredThumbnails[filter.id] = result
//                    }
//                }
//            }
        }
        .sheet(isPresented: $editorVM.showCropper) {
            if let image = editorVM.originalImage {
                ImageCropperView(image: image) { croppedImage in
                    editorVM.selectedImage = croppedImage
                }
            }
        }
        .sheet(isPresented: $editorVM.showBackgroundPicker) {
            BackgroundPickerView() { background in
                editorVM.selectedImage = background
            }
        }
//        .fullScreenCover(isPresented: $showExportDone) {
//            ExportImageDoneView(exportedImage: exportedImage ?? UIImage())
//        }
    }
    
    private func exportImage() {
        guard let selectedImage = editorVM.selectedImage else { return }
        let editorImageView = ImageView(
            image: selectedImage,
            editorVM: editorVM,
            filter: filter,
            lightness: $lightness,
            saturation: $lightness,
            blur: $blur
        )
        
        ExportEditedImageHelper.exportEditedImage(from: editorImageView) { success, message, image  in
            if success
//                , let image = image
            {
//                exportedImage = image
//                showExportDone = true
                editorVM.showAdjustBackground = false
//                showToolText = false
//                showEditText = false
//                textBoxViewModel.activeTextBox = .empty()
            }
        }
    }
}

#Preview {
    EditorView()
}
