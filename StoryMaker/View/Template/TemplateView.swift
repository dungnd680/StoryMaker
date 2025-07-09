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
    
    @State private var showSubscription = false
    @State private var showConfirmationDialog = false
    @State private var showPhotoPicker = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showCropper = false
    @State private var originalImage: UIImage? = nil
    @State private var showBackgroundPicker = false
    @State private var showAdjustBackgroundView = false
    @State private var lightness: Double = 0
    @State private var saturation: Double = 0
    @State private var blur: Double = 0
    @State private var selectedFilter: FiltersModel = filters[0]
    @State private var filteredThumbnails: [UUID: UIImage] = [:]
    @State private var showToolTextView: Bool = false
    @State private var showEditTextView: Bool = false
    @State private var isEditing: Bool = false
    
//    @StateObject private var keyboard = KeyboardObserver()
    @StateObject private var textBoxViewModel = TextBoxViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        selectedImage = nil
                        showAdjustBackgroundView = false
                        showToolTextView = false
                    } label: {
                        Image("Back")
                    }
                    .padding(.leading, 8)
                    
                    Spacer()
                    
                    Button {
                        exportImage()
                    } label: {
                        Image("Export")
                            .opacity(selectedImage == nil ? 0.5 : 1.0)
                    }
                    .disabled(selectedImage == nil)
                    .padding(.trailing, 8)
                }
                .padding(.horizontal)
                .padding(.top)
                
                ZStack {
                    if let image = selectedImage {
                        EditorImageView(
                            textBoxViewModel: textBoxViewModel,
                            lightness: $lightness,
                            saturation: $saturation,
                            blur: $blur,
                            selectedFilter: $selectedFilter,
                            showToolTextView: $showToolTextView,
                            isEditing: $isEditing,
                            showEditTextView: $showEditTextView,
                            showAdjustBackgroundView: $showAdjustBackgroundView,
                            image: image,
                            isTextFieldFocused: $isTextFieldFocused
                        )
                    } else {
                        Color.colorLightGray
                        
                        VStack {
                            Button {
                                showConfirmationDialog = true
                            } label: {
                                Image("Add Background")
                            }
                            
                            Text("Tap To Add Background")
                                .font(.system(size: 16))
                                .foregroundStyle(.black)
                        }
                        .confirmationDialog("Select Background", isPresented: $showConfirmationDialog) {
                            Button("Choose from Library") {
                                showPhotoPicker.toggle()
                            }
                            
                            Button("Other") {
                                showBackgroundPicker = true
                            }
                        }
                        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedItem)
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
                        showToolTextView = true
                    } label: {
                        VStack {
                            Image("Format Shape")
                            Text("Add Text")
                                .font(.system(size: 12))
                                .foregroundStyle(.colorDarkGray)
                        }
                        .opacity(selectedImage == nil ? 0.5 : 1.0)
                    }
                    .disabled(selectedImage == nil)
                    
                    Spacer()
                    Spacer()
                    
                    Button {
                        showAdjustBackgroundView = true
                    } label: {
                        VStack {
                            Image("Background Filter")
                            Text("Background")
                                .font(.system(size: 12))
                                .foregroundStyle(.colorDarkGray)
                        }
                        .opacity(selectedImage == nil ? 0.5 : 1.0)
                    }
                    .disabled(selectedImage == nil)
                    
                    Spacer()
                }
            }
            
            ToolTextView(isVisible: $showToolTextView)
            
            EditTextView(
                isVisible: $showEditTextView,
                showEditTextView: $showEditTextView,
                isEditing: $isEditing,
                isTextFieldFocused: $isTextFieldFocused,
                onClose: {
                    showEditTextView = false
                }
            )
            
            AdjustBackgroundView(
                lightness: $lightness,
                saturation: $saturation,
                blur: $blur,
                selectedImage: $selectedImage,
                selectedFilter: $selectedFilter,
                filteredThumbnails: $filteredThumbnails,
                isVisible: $showAdjustBackgroundView,
                onClose: { showAdjustBackgroundView = false }
            )

        }
        .ignoresSafeArea(.keyboard)
//        .onAppear {
//            showSubscription = true
//        }
        .onChange(of: selectedImage) {
            if let image = selectedImage {
                textBoxViewModel.textBoxes = []
                showAdjustBackgroundView = false
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
        .fullScreenCover(isPresented: $showSubscription) {
            SubscriptionView()
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
            showToolTextView: $showToolTextView,
            isEditing: $isEditing,
            showEditTextView: $showEditTextView,
            showAdjustBackgroundView: $showAdjustBackgroundView,
            image: selectedImage,
            isTextFieldFocused: $isTextFieldFocused
        )
        
        ExportEditedImageHelper.exportEditedImage(from: editorImageView) { success, message in
            print("Export result: \(message)")
            if success {
                showAdjustBackgroundView = false
                showToolTextView = false
                self.selectedImage = nil
            }
        }
    }
}

#Preview {
    TemplateView()
}
