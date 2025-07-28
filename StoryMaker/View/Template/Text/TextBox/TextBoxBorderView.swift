//
//  TextBoxBorderView.swift
//  StoryMaker
//
//  Created by devmacmini on 17/7/25.
//

import SwiftUI

struct TextBoxBorderView: View {

    @State private var initialDistance: CGFloat = 0
    @State private var lastScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    @State private var lastAngle: Angle = .zero
    @State private var setupValueOnDrag = false

    @Binding var scale: CGFloat
    @Binding var angle: Angle

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
                    .rotationEffect(angle)

                Image("Delete Text Box")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .offset(offsetDelete)
                    .onTapGesture {
                        onDelete()
                    }

                Image("Duplicate Text Box")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .offset(offsetDuplicate)
                    .onTapGesture {
                        onDuplicate()
                    }

                Image("Scale Text Box")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .offset(offsetScale)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let start = CGPoint(
                                    x: offsetScale.width,
                                    y: offsetScale.height
                                )

                                let current = CGPoint(
                                    x: offsetScale.width + value.translation.width,
                                    y: offsetScale.height + value.translation.height
                                )

                                let startDistance = sqrt(pow(start.x, 2) + pow(start.y, 2))
                                let currentDistance = sqrt(pow(current.x, 2) + pow(current.y, 2))

                                let deltaScale = currentDistance / startDistance

                                let proposedScale = lastScale * deltaScale

                                if proposedScale < lastScale && lastScale <= 0.5 {
                                    return
                                }

                                scale = max(0.5, min(deltaScale, 5.0))
                            }
                            .onEnded { _ in
//                                lastScale = scale
                            }
                    )
                
                Image("Rotation Text Box")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .offset(offsetRotation)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if !setupValueOnDrag {
                                    let imageOffsetX = -size.width * scale / 2
                                    let imageOffsetY = size.height * scale / 2
                                    
                                    let radians = CGFloat(angle.radians)
                                    let rotatedStartX = imageOffsetX * cos(radians) - imageOffsetY * sin(radians)
                                    let rotatedStartY = imageOffsetX * sin(radians) + imageOffsetY * cos(radians)

                                    imageOffset = CGSize(width: rotatedStartX, height: rotatedStartY)
                                    
                                    setupValueOnDrag = true
                                }

                                let initialOffsetX = imageOffset.width
                                let initialOffsetY = imageOffset.height
                                let dragedOffsetX = initialOffsetX + value.translation.width
                                let dragedOffsetY = initialOffsetY + value.translation.height

                                let a = sqrt(pow(value.translation.width, 2) + pow(value.translation.height, 2))
                                let b = sqrt(pow(initialOffsetX, 2) + pow(initialOffsetY, 2))
                                let c = sqrt(pow(dragedOffsetX, 2) + pow(dragedOffsetY, 2))

                                let cosa = (b * b + c * c - a * a) / (2 * b * c)
                                let clampedCosa = max(-1.0, min(1.0, cosa))
                                let aRadians = acos(clampedCosa)
                                var aDegrees = aRadians * 180 / .pi

                                let cross = initialOffsetX * dragedOffsetY - initialOffsetY * dragedOffsetX
                                if cross < 0 { aDegrees = -aDegrees }

                                angle = lastAngle + .degrees(aDegrees)
                            }
                            .onEnded { _ in
                                lastAngle = angle
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
                .clipShape(RoundedRectangle(cornerRadius: 68))
                .scaleEffect(2)
                .offset(x: 0, y: size.height * scale / 2 + 80)
                .rotationEffect(angle)
            }
        }
    }
    
    private var offsetDelete: CGSize {
        let dx = -size.width * scale / 2
        let dy = -size.height * scale / 2
        return rotatedOffset(dx: dx, dy: dy)
    }

    private var offsetDuplicate: CGSize {
        let dx = size.width * scale / 2
        let dy = -size.height * scale / 2
        return rotatedOffset(dx: dx, dy: dy)
    }

    private var offsetRotation: CGSize {
        let dx = -size.width * scale / 2
        let dy = size.height * scale / 2
        return rotatedOffset(dx: dx, dy: dy)
    }

    private var offsetScale: CGSize {
        let dx = size.width * scale / 2
        let dy = size.height * scale / 2
        return rotatedOffset(dx: dx, dy: dy)
    }

    private func rotatedOffset(dx: CGFloat, dy: CGFloat) -> CGSize {
        let radians = CGFloat(angle.radians)
        let rotatedX = dx * cos(radians) - dy * sin(radians)
        let rotatedY = dx * sin(radians) + dy * cos(radians)
        return CGSize(width: rotatedX, height: rotatedY)
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
