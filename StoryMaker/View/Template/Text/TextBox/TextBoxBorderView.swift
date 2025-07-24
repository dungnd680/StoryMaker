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

    @Binding var scale: CGFloat
    
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

                Image("Delete Text Box")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .offset(x: -size.width * scale / 2, y: -size.height * scale / 2)
                    .onTapGesture {
                        onDelete()
                    }

                Image("Duplicate Text Box")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .offset(x: size.width * scale / 2, y: -size.height * scale / 2)
                    .onTapGesture {
                        onDuplicate()
                    }

                Image("Rotate Text Box")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .offset(x: size.width * scale / 2, y: size.height * scale / 2)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                                let currentHandle = CGPoint(
                                    x: size.width + value.translation.width,
                                    y: size.height + value.translation.height
                                )

                                let currentDistance = hypot(currentHandle.x - center.x, currentHandle.y - center.y)

                                if initialDistance == 0 {
                                    initialDistance = currentDistance
                                }

                                let deltaScale = currentDistance / initialDistance
                                self.scale = max(0.5, min(lastScale * deltaScale, 5.0))
                            }
                            .onEnded { _ in
                                lastScale = scale
                                initialDistance = 0
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
                .foregroundStyle(.colorDarkGray)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 68))
                .scaleEffect(2)
                .offset(x: 0, y: size.height * scale / 2 + 80)
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
