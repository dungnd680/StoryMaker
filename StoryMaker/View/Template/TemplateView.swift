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
    @State private var showSubscription = false
    @State private var showConfirmationDialog = false
    @State private var showPhotoPicker = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showCropper = false
    @State private var originalImage: UIImage? = nil
    @State private var showBackgroundPicker = false
    @State private var showBrightnessView = false
    @State private var showToolTextView = false
    @State private var lightness: Double = 0
    @State private var saturation: Double = 0
    @State private var blur: Double = 0
    @State private var selectedFilter: FiltersModel = filters[0]
    @State private var filteredThumbnails: [UUID: UIImage] = [:]

    @StateObject private var viewModel = TextBoxViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        selectedImage = nil
                        showBrightnessView = false
                    } label: {
                        Image("Back")
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
                .padding(.top)
                
                ZStack {
                    if let image = selectedImage {
                        EditorImageView(
                            image: image,
                            lightness: $lightness,
                            saturation: $saturation,
                            blur: $blur,
                            selectedFilter: $selectedFilter,
                            viewModel: viewModel
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
                        viewModel.addTextBox()
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
                        showBrightnessView = true
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
            
            AdjustBackgroundView(
                lightness: $lightness,
                saturation: $saturation,
                blur: $blur,
                selectedImage: $selectedImage,
                selectedFilter: $selectedFilter,
                filteredThumbnails: $filteredThumbnails,
                isVisible: $showBrightnessView,
                onClose: { showBrightnessView = false }
            )
            
            ToolTextView(isVisible: $showToolTextView)
        }
        .ignoresSafeArea(.keyboard)
//        .onAppear {
//            showSubscription = true
//        }
        .onChange(of: selectedImage) {
            if let image = selectedImage {
                viewModel.textBoxes = []
                showBrightnessView = false
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
            image: selectedImage,
            lightness: $lightness,
            saturation: $saturation,
            blur: $blur,
            selectedFilter: $selectedFilter,
            viewModel: viewModel
        )
        
        ExportEditedImageHelper.exportEditedImage(from: editorImageView) { success, message in
            print("Export result: \(message)")
            if success {
                showBrightnessView = false
                self.selectedImage = nil
            }
        }
    }
}

#Preview {
    TemplateView()
}
