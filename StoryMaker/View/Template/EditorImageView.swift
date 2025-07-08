//
//  EditorImageView.swift
//  StoryMaker
//
//  Created by devmacmini on 20/6/25.
//

import SwiftUI

struct EditorImageView: View {

    @ObservedObject var textBoxViewModel: TextBoxViewModel
    
    @Binding var lightness: Double
    @Binding var saturation: Double
    @Binding var blur: Double
    @Binding var selectedFilter: FiltersModel
    @Binding var showToolTextView: Bool
    @Binding var isEditing: Bool
    
    let image: UIImage
    
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
                        isEditing = false
                        showToolTextView = false
                    }
                
                ForEach(textBoxViewModel.textBoxes, id: \.id) { box in
                    TextBoxView(
                        box: box,
                        textBoxViewModel: textBoxViewModel,
                        showToolTextView: $showToolTextView,
                        isEditing: $isEditing
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
