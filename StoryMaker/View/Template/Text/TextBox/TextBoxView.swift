//
//  EditTextView.swift
//  StoryMaker
//
//  Created by devmacmini on 19/6/25.
//

import SwiftUI

struct TextBoxView: View {
    
    @Environment(\.isExporting) private var isExporting
    
    @GestureState private var dragOffset: CGSize = .zero
    
    @State private var lastTapDate: Date = .distantPast
    @State private var tapWorkItem: DispatchWorkItem?
    @State private var textSize: CGSize = .zero
    
    @ObservedObject var textBoxModel: TextBoxModel
    @ObservedObject var textBoxViewModel: TextBoxViewModel
    
    @Binding var showToolTextView: Bool
    @Binding var isEditing: Bool
    @Binding var showEditTextView: Bool
    @Binding var showAdjustBackgroundView: Bool
    
    var isTextFieldFocused: FocusState<Bool>.Binding
    
    var body: some View {
        Group {
            if isExporting || (!(textBoxModel.id == textBoxViewModel.activeTextBox.id && isEditing) && !textBoxModel.content.isEmpty) {
                Text(textBoxModel.formatText)
                    .tracking(textBoxModel.letterSpacing)
            } else {
                ZStack {
                    if textBoxModel.content.isEmpty {
                        Text("Double Tap To Edit")
                            .tracking(textBoxModel.letterSpacing)
                    }
                    
                    if textBoxModel.id == textBoxViewModel.activeTextBox.id && isEditing {
                        TextField("", text: $textBoxViewModel.activeTextBox.content, axis: .vertical)
                            .tracking(textBoxModel.letterSpacing)
                            .frame(width: textSize.width, height: textSize.height)
                            .submitLabel(.return)
                            .focused(isTextFieldFocused)
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    ZStack {
                                        Text("Text Edit")
                                            .font(.headline)
                                            .foregroundStyle(.colorDarkGray)
                                        
                                        HStack {
                                            HStack {
                                                Image("Tool Edit Text")
                                                Text("Edit")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.colorDarkGray)
                                            }
                                            .onTapGesture {
                                                if !textBoxViewModel.activeTextBox.content.isEmpty {
                                                    isTextFieldFocused.wrappedValue = false
                                                    showEditTextView = true
                                                    isEditing = false
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Image("Done")
                                                .onTapGesture {
                                                    isTextFieldFocused.wrappedValue = false
                                                    isEditing = false
                                                    if !textBoxViewModel.activeTextBox.content.isEmpty {
                                                        showToolTextView = true
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                    }
                    
                    Text(textBoxViewModel.activeTextBox.content)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        textSize = geo.size
                                    }
                                    .onChange(of: geo.size) {
                                        textSize = geo.size
                                    }
                            }
                        )
                        .opacity(0)
                }
            }
        }
        .padding(48)
        .padding(textBoxModel.paddingBackgroundText)
        .font(.custom(textBoxModel.fontFamily, size: textBoxModel.sizeText))
        .lineSpacing(textBoxModel.lineHeight)
        .foregroundStyle(textBoxModel.shapeStyle)
        .opacity(textBoxModel.opacityText / 100)
        .multilineTextAlignment(textBoxModel.textAlignment)
        .shadow(
            color: Color(textBoxModel.colorShadowText).opacity(textBoxModel.opacityShadowText / 100),
            radius: textBoxModel.blurShadowText,
            x: textBoxModel.xShadowText,
            y: textBoxModel.yShadowText
        )
        .background(Color(textBoxModel.colorBackgroundText).opacity(textBoxModel.opacityBackgroundText / 100))
        .clipShape(RoundedRectangle(cornerRadius: textBoxModel.cornerBackgroundText))
        .overlay(
            GeometryReader { geo in
                TextBoxBorderView(
                    size: geo.size,
                    showBorder: textBoxModel.id == textBoxViewModel.activeTextBox.id
                )
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
        )
        .offset(x: textBoxModel.x + dragOffset.width, y: textBoxModel.y + dragOffset.height)
        .gesture(
            TapGesture()
                .onEnded {
                    let now = Date()
                    if now.timeIntervalSince(lastTapDate) < 0.3 {
                        tapWorkItem?.cancel()
                        tapWorkItem = nil
                        isEditing = true
                        textBoxViewModel.activeTextBox = textBoxModel
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            isTextFieldFocused.wrappedValue = true
                        }
                        showAdjustBackgroundView = false
                        
                        print("2 tap: \(textBoxModel.id)")
                    } else {
                        let workItem = DispatchWorkItem {
                            textBoxViewModel.activeTextBox = textBoxModel
                            isTextFieldFocused.wrappedValue = false
                            isEditing = false
                            showToolTextView = !textBoxModel.content.isEmpty

                            if textBoxModel.content.isEmpty {
                                showEditTextView = false
                            }

                            if showAdjustBackgroundView {
                                showAdjustBackgroundView = false
                                if !textBoxModel.content.isEmpty {
                                    showEditTextView = true
                                }
                            }

                            print("1 tap: \(textBoxModel.id)")
                        }

                        tapWorkItem = workItem
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)
                    }

                    lastTapDate = now
                }
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($dragOffset) { value, state, _ in
                    if (textBoxViewModel.activeTextBox.id == textBoxModel.id || textBoxViewModel.activeTextBox.isEmpty) && !isEditing {
                        state = value.translation
                    }
                }
                .onEnded { value in
                    if (textBoxViewModel.activeTextBox.id == textBoxModel.id || textBoxViewModel.activeTextBox.isEmpty) && !isEditing {
                        if let index = textBoxViewModel.textBoxes.firstIndex(where: { $0.id == textBoxModel.id }) {
                            textBoxViewModel.textBoxes[index].x += value.translation.width
                            textBoxViewModel.textBoxes[index].y += value.translation.height
                        }
                    }
                }
        )
    }
}

//#Preview {
//    TextBoxView()
//}
