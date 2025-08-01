//
//  ExportImageDoneView.swift
//  StoryMaker
//
//  Created by devmacmini on 31/7/25.
//


import SwiftUI
import Photos

struct ExportImageDoneView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let exportedImage: UIImage
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image("Close")
                        .foregroundStyle(.black.opacity(0.9))
                }
                .padding(.trailing)
            }
            .padding(.bottom)
            .padding(.top, 4)
            
            Spacer()
            
            Image(uiImage: exportedImage)
                .resizable()
                .scaledToFit()
            
            Spacer()

            VStack {
                Text("Photo saved to library")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.customDarkGray)
                    .padding(.vertical, 2)
                
                Text("Share photo to")
                    .font(.system(size: 18))
                    .foregroundStyle(.customGray2)
                    .padding(.bottom, 8)
                
                HStack(spacing: 20) {
                    Button {
                        if InstagramUtils.canOpenInstagramStories {
                            InstagramUtils.sharePhotoAsStory(exportedImage)
                        }
                    } label: {
                        VStack {
                            Image("Add Story")
                                .frame(width: 50, height: 50)
                                .background(.customWhiteGray)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text("Story")
                                .font(.caption)
                        }
                    }
                    
                    Button {
                        // Ghi ảnh ra file tạm
                        guard let imageData = exportedImage.jpegData(compressionQuality: 1.0) else { return }

                        let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                        let fileURL = tempDirectory.appendingPathComponent("exported_feed.jpg")

                        do {
                            try imageData.write(to: fileURL)
                            // Gọi post lên Instagram
                            InstagramUtils.postImage(imagePath: fileURL) { success in
                                print("Post to feed: \(success)")
                            }
                        } catch {
                            print("Failed to write image:", error)
                        }
                    } label: {
                        VStack {
                            Image("Add Feed")
                                .frame(width: 50, height: 50)
                                .background(.customWhiteGray)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text("Feed")
                                .font(.caption)
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        VStack {
                            Image("Share Message")
                                .frame(width: 50, height: 50)
                                .background(.customWhiteGray)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text("Message")
                                .font(.caption)
                        }
                    }
                    
                    ShareLink(
                        item: exportedImage,
                        preview: SharePreview("Exported Image", image: Image(uiImage: exportedImage))
                    ) {
                        VStack {
                            Image("Other")
                                .frame(width: 50, height: 50)
                                .background(.customWhiteGray)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text("Other")
                                .font(.caption)
                        }
                    }
                }
                .foregroundStyle(.customDarkGray)
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    ExportImageDoneView(exportedImage: UIImage(named: "Intro 1") ?? UIImage())
}
