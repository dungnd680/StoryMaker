//
//  EditorImageView.swift
//  StoryMaker
//
//  Created by devmacmini on 20/6/25.
//

import Foundation
import SwiftUI

struct EditorImageView: View {
    let image: UIImage
    
    @Binding var lightness: Double
    @Binding var saturation: Double
    @Binding var blur: Double
    @Binding var selectedFilter: FiltersModel
    @Binding var showToolTextView: Bool
    
    @ObservedObject var textBoxViewModel: TextBoxViewModel

    var body: some View {
        GeometryReader { geometry in
            let designSize = CGSize(width: 1080, height: 1920)
            let scale = min(geometry.size.width / designSize.width,
                            geometry.size.height / designSize.height)

            ZStack {
                Image(uiImage: applyFilter(selectedFilter, to: image))
                    .resizable()
                    .scaledToFill()
                    .frame(width: designSize.width, height: designSize.height)
                    .brightness(lightness / 100)
                    .saturation(saturation / 100 + 1)
                    .blur(radius: blur / 5.0)
                    .clipped()
                
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showToolTextView = false
                        for i in 0..<textBoxViewModel.textBoxes.count {
                            if !textBoxViewModel.textBoxes[i].text.isEmpty {
                                textBoxViewModel.textBoxes[i].isSelected = false
                                textBoxViewModel.textBoxes[i].isEditing = false
                            }
                        }
                    }
                
                ForEach($textBoxViewModel.textBoxes) { $box in
                    TextBoxView(
                        box: $box,
                        text: $box.text,
                        showToolTextView: $showToolTextView,
                        isSelected: $box.isSelected,
                        isEditing: $box.isEditing,
                        onSelect: {
                            for i in 0..<textBoxViewModel.textBoxes.count {
                                if textBoxViewModel.textBoxes[i].id != box.id && !textBoxViewModel.textBoxes[i].text.isEmpty {
                                    textBoxViewModel.textBoxes[i].isSelected = false
                                    textBoxViewModel.textBoxes[i].isEditing = false
                                }
                            }
                            
                            showToolTextView = true
                        }
                    )
                }
            }
            .frame(width: designSize.width, height: designSize.height)
            .scaleEffect(scale)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

//#Preview {
//    EditorImageView(image: UIImage(), viewModel: TextBoxViewModel())
//}
