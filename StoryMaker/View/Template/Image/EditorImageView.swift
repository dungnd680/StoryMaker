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
            
            let dragGesture = DragGesture(minimumDistance: 1)
                .onChanged { value in
                    if !textBoxViewModel.activeTextBox.isEmpty {
                        if startDragPosition == .zero {
                            startDragPosition = CGPoint(x: textBoxViewModel.activeTextBox.x,
                                                        y: textBoxViewModel.activeTextBox.y)
                        }
                        if let index = textBoxViewModel.textBoxes.firstIndex(where: { $0.id == textBoxViewModel.activeTextBox.id }) {
                            let angle = CGFloat(textBoxViewModel.activeTextBox.angle.radians)
                            let dx = value.translation.width
                            let dy = value.translation.height

                            let rotatedX = dx * cos(angle) + dy * sin(angle)
                            let rotatedY = -dx * sin(angle) + dy * cos(angle)

                            let newX = startDragPosition.x + rotatedX
                            let newY = startDragPosition.y + rotatedY
                            
                            textBoxViewModel.textBoxes[index].x = newX
                            textBoxViewModel.textBoxes[index].y = newY
                            textBoxViewModel.activeTextBox = textBoxViewModel.textBoxes[index]
                            textBoxViewModel.activeTextBoxPosition = CGPoint(x: newX, y: newY)
                        }
                    }
                }
                .onEnded { _ in
                    if !textBoxViewModel.activeTextBox.isEmpty {
                        if let index = textBoxViewModel.textBoxes.firstIndex(where: { $0.id == textBoxViewModel.activeTextBox.id }) {
                            textBoxViewModel.textBoxes[index].x = textBoxViewModel.activeTextBox.x
                            textBoxViewModel.textBoxes[index].y = textBoxViewModel.activeTextBox.y
                        }
                        startDragPosition = .zero
                    }
                }
            
            let magnificationGesture = MagnificationGesture(minimumScaleDelta: 0.01)
                .onChanged { value in
                    let newScale = currentScale * value
                    let box = textBoxViewModel.activeTextBox
                    if !box.isEmpty,
                       let index = textBoxViewModel.textBoxes.firstIndex(where: { $0.id == box.id }) {
                        let updatedBox = box
                        updatedBox.scale = newScale
                        textBoxViewModel.textBoxes[index] = updatedBox
                        textBoxViewModel.activeTextBox = updatedBox
                    }
                }
                .onEnded { value in
                    currentScale *= value
                }
            
            let rotationGesture = RotationGesture(minimumAngleDelta: .degrees(1))
                .onChanged { angle in
                    let newAngle = currentAngle + angle
                    let box = textBoxViewModel.activeTextBox
                    if !box.isEmpty,
                       let index = textBoxViewModel.textBoxes.firstIndex(where: { $0.id == box.id }) {
                        let updatedBox = box
                        updatedBox.angle = newAngle
                        textBoxViewModel.textBoxes[index] = updatedBox
                        textBoxViewModel.activeTextBox = updatedBox
                    }
                }
                .onEnded { angle in
                    currentAngle += angle
                }
            
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
                        dragGesture
                            .simultaneously(with: magnificationGesture)
                            .simultaneously(with: rotationGesture)
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
                    .scaleEffect(box.scale, anchor: .center)
                    .rotationEffect(box.angle)
                }
                
                if !textBoxViewModel.activeTextBox.isEmpty,
                   let currentBox = textBoxViewModel.textBoxes.first(where: { $0.id == textBoxViewModel.activeTextBox.id }),
                   let currentIndex = textBoxViewModel.textBoxes.firstIndex(where: { $0.id == currentBox.id }) {

                    let canMoveUp = currentIndex < textBoxViewModel.textBoxes.count - 1
                    let canMoveDown = currentIndex > 0

                    TextBoxBorderView(
                        size: textBoxViewModel.activeBoxSize,
                        scale: currentBox.scale,
                        showBorder: true,
                        onDelete: {
                            showEditText = false
                            showToolText = false
                            textBoxViewModel.delete(currentBox)
                        },
                        onDuplicate: {
                            isEditing = false
                            showToolText = true
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
                    .offset(x: textBoxViewModel.activeTextBoxPosition.x, y: textBoxViewModel.activeTextBoxPosition.y)
                    .rotationEffect(currentBox.angle)
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
//    EditorImageView(image: UIImage(), viewModel: TextBoxViewModel())
//}
