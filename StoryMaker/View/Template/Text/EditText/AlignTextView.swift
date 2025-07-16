//
//  StrokeTextView.swift
//  StoryMaker
//
//  Created by devmacmini on 15/7/25.
//

import SwiftUI

struct AlignTextView: View {
    
    @ObservedObject var textBoxModel: TextBoxModel
    @ObservedObject var textBoxViewModel: TextBoxViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Text("Align")
                    .font(.caption)
                
                Spacer()
                
                Image(systemName: "text.alignleft")
                    .frame(width: 30, height: 30)
                    .foregroundStyle(textBoxModel.alignText == .left ? .white : .colorDarkGray)
                    .background(textBoxModel.alignText == .left ? .colorDarkGray : .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            textBoxModel.alignText = .left
                        }
                        textBoxViewModel.activeTextBox.alignText = .left
                    }
                
                Image(systemName: "text.aligncenter")
                    .frame(width: 30, height: 30)
                    .foregroundStyle(textBoxModel.alignText == .center ? .white : .colorDarkGray)
                    .background(textBoxModel.alignText == .center ? .colorDarkGray : .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            textBoxModel.alignText = .center
                        }
                        textBoxViewModel.activeTextBox.alignText = .center
                    }
                
                Image(systemName: "text.alignright")
                    .frame(width: 30, height: 30)
                    .foregroundStyle(textBoxModel.alignText == .right ? .white : .colorDarkGray)
                    .background(textBoxModel.alignText == .right ? .colorDarkGray : .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            textBoxModel.alignText = .right
                        }
                        textBoxViewModel.activeTextBox.alignText = .right
                    }
            }
            .padding(.vertical, 24)
            
            HStack(spacing: 16) {
                Text("Case")
                    .font(.caption)
                
                Spacer()
                
                Text("-")
                    .frame(width: 30, height: 30)
                    .font(.subheadline)
                    .foregroundStyle(textBoxModel.caseText == .normal ? .white : .colorDarkGray)
                    .background(textBoxModel.caseText == .normal ? Color.colorDarkGray : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            textBoxModel.caseText = .normal
                        }
                        textBoxViewModel.activeTextBox.caseText = .normal
                    }
                
                Text("AG")
                    .frame(width: 30, height: 30)
                    .font(.subheadline)
                    .foregroundStyle(textBoxModel.caseText == .uppercase ? .white : .colorDarkGray)
                    .background(textBoxModel.caseText == .uppercase ? Color.colorDarkGray : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            textBoxModel.caseText = .uppercase
                        }
                        textBoxViewModel.activeTextBox.caseText = .uppercase
                    }
                
                Text("Ag")
                    .frame(width: 30, height: 30)
                    .font(.subheadline)
                    .foregroundStyle(textBoxModel.caseText == .capitalize ? .white : .colorDarkGray)
                    .background(textBoxModel.caseText == .capitalize ? Color.colorDarkGray : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            textBoxModel.caseText = .capitalize
                        }
                        textBoxViewModel.activeTextBox.caseText = .capitalize
                    }
                
                Text("ag")
                    .frame(width: 30, height: 30)
                    .font(.subheadline)
                    .foregroundStyle(textBoxModel.caseText == .lowercase ? .white : .colorDarkGray)
                    .background(textBoxModel.caseText == .lowercase ? Color.colorDarkGray : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            textBoxModel.caseText = .lowercase
                        }
                        textBoxViewModel.activeTextBox.caseText = .lowercase
                    }
            }
            
            Spacer()
        }
        .padding(.horizontal, 26)
        .frame(height: 160)
    }
}

#Preview {
    AlignTextView(textBoxModel: TextBoxModel(), textBoxViewModel: TextBoxViewModel())
}
