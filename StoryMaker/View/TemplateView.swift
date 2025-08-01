//
//  TemplateView.swift
//  StoryMaker
//
//  Created by devmacmini on 6/6/25.
//

import SwiftUI
import PhotosUI
import Mantis

struct TemplateView: View {
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var showSubscription: Bool = false
    @State private var showImageSelectionOptions: Bool = false
    @State private var showPhotoLibrary: Bool = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var originalImage: UIImage? = nil
    @State private var showCropper: Bool = false
    @State private var showBackgroundPicker: Bool = false
    @State private var showAdjustBackground: Bool = false
    @State private var selectedFilter: FilterModel = filters[0]
    @State private var filteredThumbnails: [UUID: UIImage] = [:]
    @State private var showToolText: Bool = false
    @State private var showEditText: Bool = false
    @State private var isEditing: Bool = false
    @State private var selectedTab: EditTextTab = .size
    @State private var triggerScroll: Bool = false
    @State private var exportedImage: UIImage? = nil
    @State private var showExportDone: Bool = false
    
    @State private var lightness: Double = 0
    @State private var saturation: Double = 0
    @State private var blur: Double = 0
    
    @StateObject private var textBoxViewModel = TextBoxViewModel()
    @StateObject private var textBoxModel = TextBoxModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        if selectedImage == nil {
                            Image("Back")
                        } else {
                            Button {
                                selectedImage = nil
                                showAdjustBackground = false
                                showEditText = false
                                showToolText = false
                            } label: {
                                Image("Close")
                                    .foregroundStyle(.black.opacity(0.9))
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            exportImage()
                        } label: {
                            Image("Export")
                                .opacity(selectedImage == nil ? 0.5 : 1.0)
                        }
                        .disabled(selectedImage == nil)
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                    .padding(.bottom, 2)
                    
                    ZStack {
                        if let image = selectedImage {
                            EditorImageView(
                                textBoxViewModel: textBoxViewModel,
                                lightness: $lightness,
                                saturation: $saturation,
                                blur: $blur,
                                selectedFilter: $selectedFilter,
                                showToolText: $showToolText,
                                isEditing: $isEditing,
                                showEditText: $showEditText,
                                showAdjustBackground: $showAdjustBackground,
                                image: image,
                                isTextFieldFocused: $isTextFieldFocused
                            )
                        } else {
                            Color.customLightGray
                            
                            VStack {
                                Button {
                                    showImageSelectionOptions = true
                                } label: {
                                    Image("Add Background")
                                }
                                
                                Text("Tap To Add Background")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.black)
                            }
                            .confirmationDialog("Select Background", isPresented: $showImageSelectionOptions) {
                                Button("Choose from Library") {
                                    showPhotoLibrary.toggle()
                                }
                                
                                Button("Other") {
                                    showBackgroundPicker = true
                                }
                            }
                            .photosPicker(isPresented: $showPhotoLibrary, selection: $selectedItem)
                            .onChange(of: selectedItem) {
                                Task {
                                    if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        originalImage = uiImage
                                        showCropper = true
                                        selectedItem = nil
                                    }
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            textBoxViewModel.addTextBox()
                        } label: {
                            VStack {
                                Image("Add Text")
                                Text("Add Text")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.customDarkGray)
                            }
                            .opacity(selectedImage == nil ? 0.5 : 1.0)
                        }
                        .disabled(selectedImage == nil)
                        
                        Spacer()
                        Spacer()
                        
                        Button {
                            showAdjustBackground = true
                        } label: {
                            VStack {
                                Image("Background")
                                Text("Background")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.customDarkGray)
                            }
                            .opacity(selectedImage == nil ? 0.5 : 1.0)
                        }
                        .disabled(selectedImage == nil)
                        
                        Spacer()
                    }
                }
                
                ToolTextView(
                    isVisible: $showToolText,
                    selectedTab: $selectedTab,
                    showEditTextView: $showEditText
                )
                
                EditTextView(
                    textBoxViewModel: textBoxViewModel,
                    textBoxModel: textBoxModel,
                    isVisible: $showEditText,
                    isEditing: $isEditing,
                    selectedTab: $selectedTab,
                    showSubscription: $showSubscription,
                    showToolText: $showToolText,
                    triggerScroll: $triggerScroll,
                    isTextFieldFocused: $isTextFieldFocused
                )
                
                AdjustBackgroundView(
                    lightness: $lightness,
                    saturation: $saturation,
                    blur: $blur,
                    selectedImage: $selectedImage,
                    selectedFilter: $selectedFilter,
                    filteredThumbnails: $filteredThumbnails,
                    isVisible: $showAdjustBackground,
                    onClose: { showAdjustBackground = false }
                )
                
            }
            .ignoresSafeArea(.keyboard)
            //        .onAppear {
            //            showSubscription = true
            //        }
            .onChange(of: selectedImage) {
                if let image = selectedImage {
                    textBoxViewModel.textBoxes = []
                    showAdjustBackground = false
                    lightness = 0
                    saturation = 0
                    blur = 0
                    selectedFilter = filters[0]
                    
                    filteredThumbnails = [:]
                    let thumbnail = image.resizedMaintainingAspectRatio(toMaxSize: CGSize(width: 60, height: 60))
                    for filter in filters {
                        DispatchQueue.global(qos: .userInitiated).async {
                            let result = applyFilter(filter, to: thumbnail)
                            DispatchQueue.main.async {
                                filteredThumbnails[filter.id] = result
                            }
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showSubscription) {
                SubscriptionView()
            }
            .sheet(isPresented: $showCropper) {
                if let image = originalImage {
                    ImageCropperView(image: image) { croppedImage in
                        selectedImage = croppedImage
                    }
                }
            }
            .sheet(isPresented: $showBackgroundPicker) {
                BackgroundPickerView() { background in
                    selectedImage = background
                }
            }
            .fullScreenCover(isPresented: $showExportDone) {
                ExportImageDoneView(exportedImage: exportedImage ?? UIImage())
            }
        }
    }
    
    private func exportImage() {
        guard let selectedImage = selectedImage else { return }
        let editorImageView = EditorImageView(
            textBoxViewModel: textBoxViewModel,
            lightness: $lightness,
            saturation: $saturation,
            blur: $blur,
            selectedFilter: $selectedFilter,
            showToolText: $showToolText,
            isEditing: $isEditing,
            showEditText: $showEditText,
            showAdjustBackground: $showAdjustBackground,
            image: selectedImage,
            isTextFieldFocused: $isTextFieldFocused
        )
        
        ExportEditedImageHelper.exportEditedImage(from: editorImageView) { success, message, image  in
            if success, let image = image {
                exportedImage = image
                showExportDone = true
                showAdjustBackground = false
                showToolText = false
                showEditText = false
                textBoxViewModel.activeTextBox = .empty()
            }
        }
    }
}

#Preview {
    TemplateView()
}
