//
//  TemplateView.swift
//  StoryMaker
//
//  Created by devmacmini on 6/6/25.
//

import SwiftUI
import PhotosUI
import Photos
import Mantis

struct TemplateView: View {
    @AppStorage("hideSubscription") private var hideSubscription = false
    
    @State private var showSubscription = false
    @State private var showConfirmationDialog = false
    @State private var showPhotoPicker = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showCropper = false
    @State private var apiImage: UIImage? = nil
    @State private var showBackgroundPicker = false

//    @StateObject private var viewModel = TextBoxViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let image = selectedImage {
                    EditorImageView(image: image
//                                    , viewModel: viewModel
                    )
                } else {
                    Color.colorLightGray
                    
                    VStack {
                        Image("Add Background")
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
                                apiImage = uiImage
                                showCropper = true
                                selectedItem = nil
                            }
                        }
                    }
                }
            }
            .onTapGesture {
                showConfirmationDialog = true
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        selectedImage = nil
                    } label: {
                        Image("Back")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        guard let selectedImage = selectedImage else { return }
                        let editorImageView = EditorImageView(image: selectedImage
//                                                              , viewModel: viewModel
                        )
                        
                        ExportEditedImageHelper.exportEditedImage(from: editorImageView) { success, message in
                            alertMessage = message
                            showAlert = true
                        }
                    } label: {
                        Image("Export")
                            .opacity(selectedImage == nil ? 0.5 : 1.0)
                    }
                    .disabled(selectedImage == nil)
                    .alert("Notification", isPresented: $showAlert, actions: {
                        Button("OK", role: .cancel) {
                            selectedImage = nil
                        }
                    }, message: {
                        Text(alertMessage)
                    })
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    
                    Button {
//                        viewModel.addTextBox()
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
        }
        .onAppear {
            if !hideSubscription {
                DispatchQueue.main.async {
                    showSubscription = true
                }
            }
        }
        .onChange(of: apiImage) {
            if apiImage != nil {
                showCropper = true
            }
        }
        .fullScreenCover(isPresented: $showCropper) {
            if let image = apiImage {
                ImageCropperView(
                    image: image,
                    onCrop: { croppedImage in
                        selectedImage = croppedImage
                        showCropper = false
                        showBackgroundPicker = false
                    },
                    onCancel: {
                        showCropper = false
                    }
                )
            }
        }
        .fullScreenCover(isPresented: $showBackgroundPicker) {
            BackgroundPickerView { selectedUIImage in
                apiImage = selectedUIImage
            }
        }
        .fullScreenCover(isPresented: $showSubscription) {
            SubscriptionView()
        }
    }
}

//#Preview {
//    TemplateView()
//}
