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
    @Binding var selectedFilter: FilterModel
    @Binding var showToolTextView: Bool
    @Binding var isEditing: Bool
    @Binding var showEditTextView: Bool
    @Binding var showAdjustBackgroundView: Bool
    
    let image: UIImage
    
    var isTextFieldFocused: FocusState<Bool>.Binding
    
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
                        textBoxViewModel.activeTextBox = .empty()
                        isTextFieldFocused.wrappedValue = false
                        isEditing = false
                        showToolTextView = false
                        showEditTextView = false
                    }
                
                ForEach(textBoxViewModel.textBoxes, id: \.id) { box in
                    TextBoxView(
                        box: box,
                        textBoxViewModel: textBoxViewModel,
                        showToolTextView: $showToolTextView,
                        isEditing: $isEditing,
                        showEditTextView: $showEditTextView,
                        showAdjustBackgroundView: $showAdjustBackgroundView,
                        isTextFieldFocused: isTextFieldFocused
                    )
                    .zIndex(textBoxViewModel.activeTextBox.id == box.id ? 1 : 0)
                }
            }
            .frame(width: designSize.width, height: designSize.height)
            .scaleEffect(scale)
            .frame(width: geometry.size.width, height: geometry.size.height)
//            .gesture(
//                DragGesture()
//                    .onChanged { value in
//                        let activeBox = textBoxViewModel.activeTextBox
//                        guard !activeBox.isEmpty,
//                              let index = textBoxViewModel.textBoxes.firstIndex(where: { $0.id == activeBox.id }) else { return }
//                        
//                        textBoxViewModel.textBoxes[index].x += value.translation.width
//                        textBoxViewModel.textBoxes[index].y += value.translation.height
//                    }
//            )
        }
    }
}

//#Preview {
//    EditorImageView(image: UIImage(), viewModel: TextBoxViewModel())
//}
