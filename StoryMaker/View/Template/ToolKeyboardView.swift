//
//  ToolKeyboardView.swift
//  StoryMaker
//
//  Created by devmacmini on 8/7/25.
//

import SwiftUI

struct ToolKeyboardView: View {
    
    @Binding var isEditing: Bool
    @Binding var showEditTextView: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                Color.white
                
                Text("Text Edit")
                
                HStack {
                    HStack {
                        Image("Tool Edit Text")
                        Text("Edit")
                    }
                    .onTapGesture {
                        showEditTextView = true
                    }
                    
                    Spacer()
                    
                    Image("Done")
                        .onTapGesture {
                            isEditing = false
                        }
                }
                .padding(.horizontal)
            }
            .frame(height: 45)
        }
    }
}

//#Preview {
//    ToolKeyboardView()
//}
