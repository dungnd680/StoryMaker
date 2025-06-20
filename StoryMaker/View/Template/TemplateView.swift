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

struct EditorImageView: View {
    let image: UIImage
//    @Binding var texts: [EditableText]
//    @Binding var selectedTextID: UUID?

    var body: some View {
        GeometryReader { geometry in
            let designSize = CGSize(width: 1080, height: 1920)
            let scale = min(geometry.size.width / designSize.width,
                            geometry.size.height / designSize.height)

            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: designSize.width, height: designSize.height)
                    .clipped()
                
//                ForEach($texts) { $text in
//                    EditTextView(text: $text, isSelected: selectedTextID == text.id)
//                        .onTapGesture {
//                            selectedTextID = text.id
//                        }
//                }
            }
            .frame(width: designSize.width, height: designSize.height)
            .scaleEffect(scale)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

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
    @State private var originalImage: UIImage? = nil
//    @State private var texts: [EditableText] = []
//    @State private var selectedTextID: UUID?
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let image = selectedImage {
                    EditorImageView(image: image
//                                    , texts: $texts, selectedTextID: $selectedTextID
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
//                                                              , texts: $texts, selectedTextID: $selectedTextID
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
//                        addNewText()
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
        .fullScreenCover(isPresented: $showCropper) {
            if let image = originalImage {
                ImageCropperView(image: image) { croppedImage in
                    selectedImage = croppedImage
                }
            }
        }
        .fullScreenCover(isPresented: $showSubscription) {
            SubscriptionView()
        }
    }
    
//    func addNewText() {
//        let newText = EditableText(text: "Text", position: CGPoint(x: 150, y: 150), fontSize: 24, color: .black)
//        texts.append(newText)
//        selectedTextID = newText.id
//    }
}

#Preview {
    TemplateView()
}
