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
    
    var body: some View {
        if showBorder {
            ZStack {
                Rectangle()
                    .stroke(.white, lineWidth: 6)
                    .stroke(.black, lineWidth: 3)
                    .frame(width: size.width, height: size.height)

                Button {
                    
                } label: {
                    Image("Delete Text")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .offset(x: -size.width / 2, y: -size.height / 2)
                }

                Button {
                    
                } label: {
                    Image("Duplicate Text")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .offset(x: size.width / 2, y: -size.height / 2)
                }

                Button {
                    
                } label: {
                    Image("Rotate Text")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .offset(x: -size.width / 2, y: size.height / 2)
                }

                Button {
                    
                } label: {
                    Image("Scale Text")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .offset(x: size.width / 2, y: size.height / 2)
                }
                
                HStack(spacing: 18) {
                    Button {
                        
                    } label: {
                        HStack(spacing: 0) {
                            Image(systemName: "arrow.up")
                            Image(systemName: "square.3.layers.3d.top.filled")
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        HStack(spacing: 0) {
                            Image(systemName: "square.3.layers.3d.top.filled")
                            Image(systemName: "arrow.down")
                        }
                    }
                }
                .frame(width: 120, height:  40)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 68))
                .scaleEffect(2)
                .offset(x: 0, y: size.height / 2 + 80)
            }
        }
    }
}

#Preview {
    TextBoxBorderView(size: CGSize(width: 200, height: 100), showBorder: true)
}
