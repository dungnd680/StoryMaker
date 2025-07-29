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
                                    let dx = size.width * scale / 2
                                    let dy = size.height * scale / 2

                                    let radians = CGFloat(rotation.radians)
                                    let rotatedStartX = dx * cos(radians) - dy * sin(radians)
                                    let rotatedStartY = dx * sin(radians) + dy * cos(radians)

                                    initialScaleOffset = CGPoint(x: rotatedStartX, y: rotatedStartY)
                                    setupValueOnDrag = true
                                }

                                let draggedOffset = CGPoint(
                                    x: initialScaleOffset.x + value.translation.width,
                                    y: initialScaleOffset.y + value.translation.height
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
                                    let dx = -size.width * scale / 2
                                    let dy = size.height * scale / 2
                                    
                                    let radians = CGFloat(rotation.radians)
                                    let rotatedStartX = dx * cos(radians) - dy * sin(radians)
                                    let rotatedStartY = dx * sin(radians) + dy * cos(radians)

                                    initialRotationOffset = CGPoint(x: rotatedStartX, y: rotatedStartY)
                                    
                                    setupValueOnDrag = true
                                }
                                
                                let initialOffset = (
                                    x: initialRotationOffset.x,
                                    y: initialRotationOffset.y
                                )
                                let draggedOffset = (
                                    x: initialRotationOffset.x + value.translation.width,
                                    y: initialRotationOffset.y + value.translation.height
                                )

                                let a = hypot(draggedOffset.x - initialOffset.x, draggedOffset.y - initialOffset.y)
                                let b = hypot(initialOffset.x, initialOffset.y)
                                let c = hypot(draggedOffset.x, draggedOffset.y)

                                let cosa = (b * b + c * c - a * a) / (2 * b * c)
                                let clampedCosa = max(-1.0, min(1.0, cosa))
                                let aRadians = acos(clampedCosa)
                                var aDegrees = aRadians * 180 / .pi

                                let cross = initialOffset.x * draggedOffset.y - initialOffset.y * draggedOffset.x
                                if cross < 0 { aDegrees = -aDegrees }

                                rotation = lastRotation + .degrees(aDegrees)
                            }
                            .onEnded { _ in
                                lastRotation = rotation
                                setupValueOnDrag = false
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
            .onAppear {
                lastScale = scale
                lastRotation = rotation
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
