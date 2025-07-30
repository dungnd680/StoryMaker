//
//  TextBoxBorderView.swift
//  StoryMaker
//
//  Created by devmacmini on 17/7/25.
//

import SwiftUI

struct TextBoxBorderView: View {

    @State private var lastScale: CGFloat = 1.0
    @State private var lastRotation: Angle = .zero
    @State private var initialScaleOffset: CGPoint = .zero
    @State private var initialRotationOffset: CGPoint = .zero
    @State private var initialScaleTranslation: CGSize = .zero
    @State private var initialRotationTranslation: CGSize = .zero
    @State private var setupValueOnDrag = false

    @Binding var scale: CGFloat
    @Binding var rotation: Angle

    var size: CGSize
    var showBorder: Bool
    var onDelete: () -> Void
    var onDuplicate: () -> Void
    var moveUp: () -> Void
    var moveDown: () -> Void
    var canMoveUp: Bool
    var canMoveDown: Bool

    var body: some View {
        if showBorder {
            ZStack {
                Rectangle()
                    .stroke(.white, lineWidth: 6)
                    .stroke(.black, lineWidth: 3)
                    .frame(width: size.width * scale, height: size.height * scale)
                    .rotationEffect(rotation)

                Image("Delete Text Box")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .offset(x: -size.width * scale / 2, y: -size.height * scale / 2)
                    .rotationEffect(rotation)
                    .onTapGesture {
                        onDelete()
                    }

                Image("Duplicate Text Box")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .offset(x: size.width * scale / 2, y: -size.height * scale / 2)
                    .rotationEffect(rotation)
                    .onTapGesture {
                        onDuplicate()
                    }

                Image("Scale Text Box")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .offset(x: size.width * scale / 2, y: size.height * scale / 2)
                    .rotationEffect(rotation)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if !setupValueOnDrag {
                                    lastScale = scale
                                    
                                    let dx = size.width * scale / 2
                                    let dy = size.height * scale / 2

                                    let radians = CGFloat(rotation.radians)
                                    let rotatedX = dx * cos(radians) - dy * sin(radians)
                                    let rotatedY = dx * sin(radians) + dy * cos(radians)

                                    initialScaleOffset = CGPoint(x: rotatedX, y: rotatedY)
                                    initialScaleTranslation = value.translation
                                    setupValueOnDrag = true
                                }

                                let draggedOffset = CGPoint(
                                    x: initialScaleOffset.x + (value.translation.width - initialScaleTranslation.width),
                                    y: initialScaleOffset.y + (value.translation.height - initialScaleTranslation.height)
                                )

                                let a = hypot(initialScaleOffset.x, initialScaleOffset.y)
                                let b = hypot(draggedOffset.x, draggedOffset.y)

                                let ratioScale = b / a
                                let Scale = lastScale * ratioScale

                                scale = max(0.5, min(Scale, 5.0))
                            }
                            .onEnded { _ in
                                lastScale = scale
                                setupValueOnDrag = false
                            }
                    )
                
                Image("Rotation Text Box")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .offset(x: -size.width * scale / 2, y: size.height * scale / 2)
                    .rotationEffect(rotation)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if !setupValueOnDrag {
                                    lastRotation = rotation

                                    let dx = -size.width * scale / 2
                                    let dy = size.height * scale / 2

                                    let radians = CGFloat(rotation.radians)
                                    let rotatedX = dx * cos(radians) - dy * sin(radians)
                                    let rotatedY = dx * sin(radians) + dy * cos(radians)

                                    initialRotationOffset = CGPoint(x: rotatedX, y: rotatedY)
                                    initialRotationTranslation = value.translation
                                    setupValueOnDrag = true
                                }

                                let dragedOffset = CGPoint(
                                    x: initialRotationOffset.x + (value.translation.width - initialRotationTranslation.width),
                                    y: initialRotationOffset.y + (value.translation.height - initialRotationTranslation.height)
                                )

                                let angle1 = atan2(initialRotationOffset.y, initialRotationOffset.x)
                                let angle2 = atan2(dragedOffset.y, dragedOffset.x)
                                let delta = angle2 - angle1

                                rotation = lastRotation + .radians(delta)
                            }
                            .onEnded { _ in
                                lastRotation = rotation
                                setupValueOnDrag = false
                                initialRotationTranslation = .zero
                            }
                    )

                HStack(spacing: 16) {
                    Button {
                        moveUp()
                    } label: {
                        HStack(spacing: 0) {
                            Image(systemName: "arrow.up")
                            Image(systemName: "square.3.layers.3d.top.filled")
                        }
                    }
                    .disabled(!canMoveUp)
                    .opacity(canMoveUp ? 1 : 0.3)

                    Button {
                        moveDown()
                    } label: {
                        HStack(spacing: 0) {
                            Image(systemName: "square.3.layers.3d.top.filled")
                            Image(systemName: "arrow.down")
                        }
                    }
                    .disabled(!canMoveDown)
                    .opacity(canMoveDown ? 1 : 0.3)
                }
                .frame(width: 110, height:  40)
                .foregroundStyle(.customDarkGray)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 70))
                .scaleEffect(2)
                .offset(x: 0, y: size.height * scale / 2 + 80)
                .rotationEffect(rotation)
            }
        }
    }
}

//#Preview {
//    TextBoxBorderView(
//        size: CGSize(width: 200, height: 100),
//        showBorder: true,
//        onDelete: {},
//        onDuplicate: {},
//        moveUp: {},
//        moveDown: {}
//    )
//}
