////
////  StrokeTextView.swift
////  StoryMaker
////
////  Created by devmacmini on 15/7/25.
////
//
//import SwiftUI
//
//struct AlignTextView: View {
//    
//    @ObservedObject var textBoxModel: TextBox
//    @ObservedObject var textBoxViewModel: TextBoxViewModel
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            HStack(spacing: 16) {
//                Text("Align")
//                    .font(.caption)
//                
//                Spacer()
//                
//                Image(systemName: "text.alignleft")
//                    .frame(width: 30, height: 30)
//                    .foregroundStyle(textBoxModel.alignText == .left ? .white : .customDarkGray)
//                    .background(textBoxModel.alignText == .left ? .customDarkGray : .clear)
//                    .clipShape(RoundedRectangle(cornerRadius: 4))
//                    .onTapGesture {
//                        withAnimation(.easeInOut(duration: 0.2)) {
//                            textBoxModel.alignText = .left
//                        }
//                        textBoxViewModel.activeTextBox.alignText = .left
//                    }
//                
//                Image(systemName: "text.aligncenter")
//                    .frame(width: 30, height: 30)
//                    .foregroundStyle(textBoxModel.alignText == .center ? .white : .customDarkGray)
//                    .background(textBoxModel.alignText == .center ? .customDarkGray : .clear)
//                    .clipShape(RoundedRectangle(cornerRadius: 4))
//                    .onTapGesture {
//                        withAnimation(.easeInOut(duration: 0.2)) {
//                            textBoxModel.alignText = .center
//                        }
//                        textBoxViewModel.activeTextBox.alignText = .center
//                    }
//                
//                Image(systemName: "text.alignright")
//                    .frame(width: 30, height: 30)
//                    .foregroundStyle(textBoxModel.alignText == .right ? .white : .customDarkGray)
//                    .background(textBoxModel.alignText == .right ? .customDarkGray : .clear)
//                    .clipShape(RoundedRectangle(cornerRadius: 4))
//                    .onTapGesture {
//                        withAnimation(.easeInOut(duration: 0.2)) {
//                            textBoxModel.alignText = .right
//                        }
//                        textBoxViewModel.activeTextBox.alignText = .right
//                    }
//            }
//            .padding(.vertical, 24)
//            
//            HStack(spacing: 16) {
//                Text("Case")
//                    .font(.caption)
//                
//                Spacer()
//                
//                Text("-")
//                    .frame(width: 30, height: 30)
//                    .font(.subheadline)
//                    .foregroundStyle(textBoxModel.caseText == .normal ? .white : .customDarkGray)
//                    .background(textBoxModel.caseText == .normal ? .customDarkGray : .clear)
//                    .clipShape(RoundedRectangle(cornerRadius: 4))
//                    .onTapGesture {
//                        withAnimation(.easeInOut(duration: 0.2)) {
//                            textBoxModel.caseText = .normal
//                        }
//                        textBoxViewModel.activeTextBox.caseText = .normal
//                    }
//                
//                Text("AG")
//                    .frame(width: 30, height: 30)
//                    .font(.subheadline)
//                    .foregroundStyle(textBoxModel.caseText == .uppercase ? .white : .customDarkGray)
//                    .background(textBoxModel.caseText == .uppercase ? .customDarkGray : Color.clear)
//                    .clipShape(RoundedRectangle(cornerRadius: 4))
//                    .onTapGesture {
//                        withAnimation(.easeInOut(duration: 0.2)) {
//                            textBoxModel.caseText = .uppercase
//                        }
//                        textBoxViewModel.activeTextBox.caseText = .uppercase
//                    }
//                
//                Text("Ag")
//                    .frame(width: 30, height: 30)
//                    .font(.subheadline)
//                    .foregroundStyle(textBoxModel.caseText == .capitalize ? .white : .customDarkGray)
//                    .background(textBoxModel.caseText == .capitalize ? .customDarkGray : Color.clear)
//                    .clipShape(RoundedRectangle(cornerRadius: 4))
//                    .onTapGesture {
//                        withAnimation(.easeInOut(duration: 0.2)) {
//                            textBoxModel.caseText = .capitalize
//                        }
//                        textBoxViewModel.activeTextBox.caseText = .capitalize
//                    }
//                
//                Text("ag")
//                    .frame(width: 30, height: 30)
//                    .font(.subheadline)
//                    .foregroundStyle(textBoxModel.caseText == .lowercase ? .white : .customDarkGray)
//                    .background(textBoxModel.caseText == .lowercase ? .customDarkGray : Color.clear)
//                    .clipShape(RoundedRectangle(cornerRadius: 4))
//                    .onTapGesture {
//                        withAnimation(.easeInOut(duration: 0.2)) {
//                            textBoxModel.caseText = .lowercase
//                        }
//                        textBoxViewModel.activeTextBox.caseText = .lowercase
//                    }
//            }
//            
//            Spacer()
//        }
//        .padding(.horizontal, 26)
//        .frame(height: 160)
//    }
//}
//
//#Preview {
//    AlignTextView(textBoxModel: TextBox(), textBoxViewModel: TextBoxViewModel())
//}
