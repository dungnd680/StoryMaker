//
//  EditorImageView.swift
//  StoryMaker
//
//  Created by devmacmini on 20/6/25.
//

import SwiftUI

struct EditorImageView: View {
    
    @State private var startDragPosition: CGPoint = .zero
    @State private var currentScale: CGFloat = 1.0
    @State private var currentAngle: Angle = .zero

    @ObservedObject var textBoxViewModel: TextBoxViewModel
    
    @Binding var lightness: Double
    @Binding var saturation: Double
    @Binding var blur: Double
    @Binding var selectedFilter: FilterModel
    @Binding var showToolText: Bool
    @Binding var isEditing: Bool
    @Binding var showEditText: Bool
    @Binding var showAdjustBackground: Bool
    
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
                    .gesture(
                        DragGesture(minimumDistance: 1)
                            .onChanged { value in
                                if !textBoxViewModel.activeTextBox.id.isEmpty {
                                    if startDragPosition == .zero {
                                        startDragPosition = CGPoint(x: textBoxViewModel.activeTextBox.x,
                                                                    y: textBoxViewModel.activeTextBox.y)
                                    }
                                    if let index = textBoxViewModel.textBoxes.firstIndex(where: { $0.id == textBoxViewModel.activeTextBox.id }) {
                                        let newX = startDragPosition.x + value.translation.width
                                        let newY = startDragPosition.y + value.translation.height
                                        textBoxViewModel.textBoxes[index].x = newX
                                        textBoxViewModel.textBoxes[index].y = newY
                                        textBoxViewModel.activeTextBoxOffset = CGPoint(x: newX, y: newY)
                                    }
                                }
                            }
                            .onEnded { _ in
                                startDragPosition = .zero
                            }
                    )
                    .onTapGesture {
                        textBoxViewModel.activeTextBox = .empty()
                        isTextFieldFocused.wrappedValue = false
                        isEditing = false
                        showToolText = false
                        showEditText = false
                    }
                
                ForEach(textBoxViewModel.textBoxes, id: \.id) { box in
                    TextBoxView(
                        textBoxModel: box,
                        textBoxViewModel: textBoxViewModel,
                        showToolText: $showToolText,
                        isEditing: $isEditing,
                        showEditText: $showEditText,
                        showAdjustBackground: $showAdjustBackground,
                        isTextFieldFocused: isTextFieldFocused
                    )
                }
                
                if !textBoxViewModel.activeTextBox.id.isEmpty,
                   let currentBox = textBoxViewModel.textBoxes.first(where: { $0.id == textBoxViewModel.activeTextBox.id }),
                   let currentIndex = textBoxViewModel.textBoxes.firstIndex(where: { $0.id == currentBox.id }) {

                    let canMoveUp = currentIndex < textBoxViewModel.textBoxes.count - 1
                    let canMoveDown = currentIndex > 0

                    TextBoxBorderView(
                        scale: $textBoxViewModel.textBoxes[currentIndex].scale,
                        angle: $textBoxViewModel.textBoxes[currentIndex].angle,
                        size: textBoxViewModel.activeBoxSize,
                        showBorder: true,
                        onDelete: {
                            showEditText = false
                            showToolText = false
                            textBoxViewModel.delete(currentBox)
                        },
                        onDuplicate: {
                            isEditing = false
                            if !textBoxViewModel.activeTextBox.content.isEmpty {
                                showToolText = true
                            }
                            textBoxViewModel.duplicate(currentBox)
                        },
                        moveUp: {
                            textBoxViewModel.up(currentBox)
                        },
                        moveDown: {
                            textBoxViewModel.down(currentBox)
                        },
                        canMoveUp: canMoveUp,
                        canMoveDown: canMoveDown
                    )
                    .offset(x: textBoxViewModel.activeTextBoxOffset.x, y: textBoxViewModel.activeTextBoxOffset.y)
                }
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

//#Preview {
//    EditorImageView()
//}
