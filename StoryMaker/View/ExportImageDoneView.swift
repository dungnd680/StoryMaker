//
//  ExportImageDoneView.swift
//  StoryMaker
//
//  Created by devmacmini on 31/7/25.
//

import SwiftUI

struct ExportImageDoneView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let exportedImage: UIImage
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("Back")
                }
                .padding(.leading)
                
                Spacer()
            }
            .padding(.bottom)
            .padding(.top, 4)
            
            Image(uiImage: exportedImage)
                .resizable()
                .scaledToFit()

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
                    ForEach([
                        ("Add Story", "Story"),
                        ("Add Feed", "Feed"),
                        ("Share Message", "Message"),
                        ("Other", "Other")
                    ], id: \.1) { icon, label in
                        Button {
                            
                        } label: {
                            VStack {
                                Image(icon)
                                    .frame(width: 50, height: 50)
                                    .background(.customWhiteGray)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                Text(label)
                                    .font(.caption)
                            }
                        }
                    }
                }
                .foregroundStyle(.customDarkGray)
            }
            .padding(.bottom)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ExportImageDoneView(exportedImage: UIImage(named: "Intro 1") ?? UIImage())
}
