////
////  BackgroundTextView.swift
////  StoryMaker
////
////  Created by devmacmini on 16/7/25.
////
//
//import SwiftUI
//
//struct BackgroundTextView: View {
//    
//    @State private var colorPickerBackgroundText: Color = .clear
//    
//    @ObservedObject var textBoxViewModel: TextBoxViewModel
//    
//    @Binding var colorBackgroundText: String
//    @Binding var paddingBackgroundText: CGFloat
//    @Binding var cornerBackgroundText: CGFloat
//    @Binding var opacityBackgroundText: CGFloat
//    @Binding var triggerScroll: Bool
//
//    var body: some View {
//        VStack {
//            Spacer()
//            
//            VStack(alignment: .leading, spacing: 8) {
//                SlidersView(value: $paddingBackgroundText, label: "Padding", range: 0...100)
//                SlidersView(value: $cornerBackgroundText, label: "Corner", range: 0...100)
//                SlidersView(value: $opacityBackgroundText, label: "Opacity", range: 0...100)
//            }
//            .padding(.leading, 26)
//            .padding(.trailing)
//            .padding(.bottom, 8)
//            
//            ScrollViewReader { proxy in
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack {
//                        Circle()
//                            .foregroundStyle(Color("#00000000"))
//                            .frame(width: 55, height: 55)
//                            .overlay {
//                                ZStack {
//                                    Circle().stroke(.yellow, lineWidth: 1)
//                                    
//                                    if colorBackgroundText == "#00000000" {
//                                        Circle().stroke(.customRed, lineWidth: 2)
//                                        Image("Selected Color")
//                                    }
//                                }
//                            }
//                            .onTapGesture {
//                                colorBackgroundText = "#00000000"
//                            }
//                        
//                        ColorPicker("", selection: $colorPickerBackgroundText, supportsOpacity: false)
//                            .labelsHidden()
//                            .frame(width: 55, height: 55)
//                            .scaleEffect(2)
//                            .onChange(of: colorPickerBackgroundText) {
//                                colorBackgroundText = colorPickerBackgroundText.toHex()
//                            }
//                        
//                        ForEach(Colors.solidColors, id: \.self) { hex in
//                            Circle()
//                                .foregroundStyle(Color(hex))
//                                .frame(width: 55, height: 55)
//                                .overlay {
//                                    ZStack {
//                                        if hex == "#FFFFFF" {
//                                            Circle().stroke(.customDarkGray)
//                                        }
//                                        
//                                        if colorBackgroundText == hex {
//                                            Circle().stroke(.customRed, lineWidth: 2)
//                                            Image("Selected Color")
//                                        }
//                                    }
//                                }
//                                .id(hex)
//                                .onTapGesture {
//                                    colorBackgroundText = hex
//                                    withAnimation(.easeInOut(duration: 0.2)) {
//                                        proxy.scrollTo(hex, anchor: .center)
//                                    }
//                                }
//                        }
//                    }
//                    .padding(.horizontal, 26)
//                    .padding(.bottom, 48)
//                    .frame(height: 110)
//                }
//                .onAppear {
//                    if colorBackgroundText.hasPrefix("#") {
//                        proxy.scrollTo(colorBackgroundText, anchor: .center)
//                    }
//                }
//                .onChange(of: triggerScroll) {
//                    if colorBackgroundText.hasPrefix("#") {
//                        proxy.scrollTo(colorBackgroundText, anchor: .center)
//                    }
//                }
//                .onChange(of: textBoxViewModel.activeTextBox.id) {
//                    if colorBackgroundText.hasPrefix("#") {
//                        withAnimation(.easeInOut(duration: 0.2)) {
//                            proxy.scrollTo(colorBackgroundText, anchor: .center)
//                        }
//                    }
//                }
//            }
//        }
//        .frame(height: 300)
//    }
//}
//
//#Preview {
//    BackgroundTextView(
//        textBoxViewModel: TextBoxViewModel(),
//        colorBackgroundText: .constant("#000000"),
//        paddingBackgroundText: .constant(10),
//        cornerBackgroundText: .constant(8),
//        opacityBackgroundText: .constant(80),
//        triggerScroll: .constant(false)
//    )
//}
