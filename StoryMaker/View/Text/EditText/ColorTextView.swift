////
////  ColorTextView.swift
////  StoryMaker
////
////  Created by devmacmini on 14/7/25.
////
//
//import SwiftUI
//
//struct ColorTextView: View {
//    
//    @State private var colorPicker: Color = .white
//    
//    @ObservedObject var textBoxViewModel: TextBoxViewModel
//    
//    @Binding var colorText: TextFill
//    @Binding var triggerScroll: Bool
//    
//    var body: some View {
//        ScrollViewReader { proxy in
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack {
//                    ColorPicker("", selection: $colorPicker, supportsOpacity: false)
//                        .labelsHidden()
//                        .frame(width: 55, height: 55)
//                        .scaleEffect(2)
//                        .onChange(of: colorPicker) {
//                            colorText = .solid(colorPicker.toHex())
//                        }
//                    
//                    ForEach(Colors.solidColors, id: \.self) { hex in
//                        Circle()
//                            .foregroundStyle(Color(hex))
//                            .frame(width: 55, height: 55)
//                            .overlay {
//                                ZStack {
//                                    if hex == "#FFFFFF" {
//                                        Circle()
//                                            .stroke(.customDarkGray)
//                                    }
//                                    
//                                    if case .solid(let selectedHex) = colorText, selectedHex == hex {
//                                        Circle()
//                                            .stroke(Color.customRed, lineWidth: 2)
//                                        Image("Selected Color")
//                                    }
//                                }
//                            }
//                            .id(hex)
//                            .onTapGesture {
//                                colorText = .solid(hex)
//                                withAnimation(.easeInOut(duration: 0.2)) {
//                                    proxy.scrollTo(hex, anchor: .center)
//                                }
//                            }
//                    }
//                }
//                .padding(.horizontal, 26)
//                .padding(.bottom, 48)
//                .frame(height: 110)
//            }
//            .onAppear {
//                if case .solid(let selectedHex) = colorText {
//                    proxy.scrollTo(selectedHex, anchor: .center)
//                }
//            }
//            .onChange(of: triggerScroll) {
//                if case .solid(let selectedHex) = colorText {
//                    proxy.scrollTo(selectedHex, anchor: .center)
//                }
//            }
//            .onChange(of: textBoxViewModel.activeTextBox.id) {
//                if case .solid(let selectedHex) = colorText {
//                    withAnimation(.easeInOut(duration: 0.2)) {
//                        proxy.scrollTo(selectedHex, anchor: .center)
//                    }
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ColorTextView(
//        textBoxViewModel: TextBoxViewModel(),
//        colorText: .constant(.solid("#FFFFFF")),
//        triggerScroll: .constant(false)
//    )
//}
