//
//  TextBoxBorderView.swift
//  StoryMaker
//
//  Created by devmacmini on 17/7/25.
//

import SwiftUI

struct TextBoxBorderView: View {
    
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
                    .frame(width: size.width, height: size.height)

                Image("Delete Text Box")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .offset(x: -size.width / 2, y: -size.height / 2)
                    .onTapGesture {
                        onDelete()
                    }

                Image("Duplicate Text Box")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .offset(x: size.width / 2, y: -size.height / 2)
                    .onTapGesture {
                        onDuplicate()
                    }

                Image("Rotate Text Box")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .offset(x: size.width / 2, y: size.height / 2)
                    .onTapGesture {
                        
                    }
                
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
                .offset(x: 0, y: size.height / 2 + 80)
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
