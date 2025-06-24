//
//  EditorImageView.swift
//  StoryMaker
//
//  Created by devmacmini on 20/6/25.
//

import SwiftUI

struct EditorImageView: View {
    let image: UIImage
//    @ObservedObject var viewModel: TextBoxViewModel
    
    
    var body: some View {
        GeometryReader { geometry in
            let designSize = CGSize(width: 1080, height: 1920)
            let scale = min(geometry.size.width / designSize.width,
                            geometry.size.height / designSize.height)

            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: designSize.width, height: designSize.height)
                    .clipped()
                
//                ForEach($viewModel.textBoxes) { $box in
//                    TextBoxView(box: $box, text: $box.text)
//                }
            }
            .frame(width: designSize.width, height: designSize.height)
            .scaleEffect(scale)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

//#Preview {
//    EditorImageView(image: UIImage(), viewModel: TextBoxViewModel())
//}
