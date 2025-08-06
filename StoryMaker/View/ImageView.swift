//
//  EditorImageView.swift
//  StoryMaker
//
//  Created by devmacmini on 20/6/25.
//

import SwiftUI

struct ImageView: View {
    
//    @Environment(\.isExporting) private var isExporting

//    @State private var initialOffset: CGPoint = .zero
//    @State private var initialDragTranslation: CGSize = .zero
    
    let image: UIImage
    
    @ObservedObject var editorVM: EditorVM
    @ObservedObject var filter: Filter

//    @ObservedObject var textBoxViewModel: TextBoxViewModel
//    @ObservedObject var textBox: TextBox
    
    @Binding var lightness: Double
    @Binding var saturation: Double
    @Binding var blur: Double
//    @Binding var selectedFilter: FilterModel
//    @Binding var showToolText: Bool
//    @Binding var isEditing: Bool
//    @Binding var showEditText: Bool
//    @Binding var showAdjustBackground: Bool

//    var isTextFieldFocused: FocusState<Bool>.Binding
    
    var body: some View {
        GeometryReader { geometry in
            let designSize = CGSize(width: 1080, height: 1920)
            let scale = min(geometry.size.width / designSize.width,
                            geometry.size.height / designSize.height)
            
            ZStack {
//                if let image = image {
                Image(uiImage: Filter.apply(filter.type, to: image))
                    .resizable()
                    .scaledToFill()
                    .frame(width: designSize.width, height: designSize.height)
                    .brightness(lightness / 100)
                    .saturation(saturation / 100 + 1)
                    .blur(radius: blur / 5.0)
                    .clipped()
//                }
                
//                Color.clear
//                    .contentShape(Rectangle())
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                if !textBoxViewModel.activeTextBox.id.isEmpty {
//                                    if initialOffset == .zero && initialDragTranslation == .zero {
//                                        initialOffset = CGPoint(
//                                            x: textBoxViewModel.activeTextBox.x,
//                                            y: textBoxViewModel.activeTextBox.y
//                                        )
//                                        initialDragTranslation = value.translation
//                                    }
//                                    
//                                    if let index = textBoxViewModel.textBoxes.firstIndex(where: { $0.id == textBoxViewModel.activeTextBox.id }) {
//                                        let dragedOffset = (
//                                            x: initialOffset.x + (value.translation.width - initialDragTranslation.width),
//                                            y: initialOffset.y + (value.translation.height - initialDragTranslation.height)
//                                        )
//                                        
//                                        textBoxViewModel.textBoxes[index].x = dragedOffset.x
//                                        textBoxViewModel.textBoxes[index].y = dragedOffset.y
//                                        textBoxViewModel.borderTextBoxOffset = CGPoint(x: dragedOffset.x, y: dragedOffset.y)
//                                    }
//                                }
//                            }
//                            .onEnded { _ in
//                                initialOffset = .zero
//                                initialDragTranslation = .zero
//                            }
//                    )
//                    .onTapGesture {
//                        textBoxViewModel.activeTextBox = .empty()
//                        isTextFieldFocused.wrappedValue = false
//                        isEditing = false
//                        showToolText = false
//                        showEditText = false
//                    }
                
//                ForEach(textBoxViewModel.textBoxes, id: \.id) { box in
//                    TextBoxView(
//                        textBoxModel: box,
//                        textBoxViewModel: textBoxViewModel,
//                        showToolText: $showToolText,
//                        isEditing: $isEditing,
//                        showEditText: $showEditText,
//                        showAdjustBackground: $showAdjustBackground,
//                        isTextFieldFocused: isTextFieldFocused
//                    )
//                }
                
//                if !isExporting {
//                    if !textBoxViewModel.activeTextBox.id.isEmpty,
//                       let currentBox = textBoxViewModel.textBoxes.first(where: { $0.id == textBoxViewModel.activeTextBox.id }),
//                       let currentIndex = textBoxViewModel.textBoxes.firstIndex(where: { $0.id == currentBox.id }) {
//
//                        let canMoveUp = currentIndex < textBoxViewModel.textBoxes.count - 1
//                        let canMoveDown = currentIndex > 0
//
//                        TextBoxBorderView(
//                            scale: $textBoxViewModel.textBoxes[currentIndex].scale,
//                            rotation: $textBoxViewModel.textBoxes[currentIndex].rotation,
//                            size: textBoxViewModel.activeBoxSize,
//                            showBorder: true,
//                            onDelete: {
//                                showEditText = false
//                                showToolText = false
//                                textBoxViewModel.delete(currentBox)
//                            },
//                            onDuplicate: {
//                                isEditing = false
//                                if !textBoxViewModel.activeTextBox.content.isEmpty {
//                                    showToolText = true
//                                }
//                                textBoxViewModel.duplicate(currentBox)
//                            },
//                            moveUp: {
//                                textBoxViewModel.up(currentBox)
//                            },
//                            moveDown: {
//                                textBoxViewModel.down(currentBox)
//                            },
//                            canMoveUp: canMoveUp,
//                            canMoveDown: canMoveDown
//                        )
//                        .offset(x: textBoxViewModel.borderTextBoxOffset.x, y: textBoxViewModel.borderTextBoxOffset.y)
//                    }
//                }
            }
            .frame(width: designSize.width, height: designSize.height)
            .mask(
                Rectangle()
                    .frame(width: designSize.width, height: designSize.height)
            )
            .scaleEffect(scale)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    ImageView(
        image: UIImage(named: "Preview Photo") ?? UIImage(),
        editorVM: EditorVM(),
        filter: Filter(),
        lightness: .constant(0),
        saturation: .constant(0),
        blur: .constant(0)
    )
}
