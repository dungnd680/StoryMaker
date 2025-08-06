////
////  ShadowTextView.swift
////  StoryMaker
////
////  Created by devmacmini on 16/7/25.
////
//
//import SwiftUI
//
//struct ShadowTextView: View {
//    
//    @State private var colorPickerShadowText: Color = .white
//    
//    @ObservedObject var textBoxViewModel: TextBoxViewModel
//    
//    @Binding var colorShadowText: String
//    @Binding var opacityShadowText: CGFloat
//    @Binding var blurShadowText: CGFloat
//    @Binding var xShadowText: CGFloat
//    @Binding var yShadowText: CGFloat
//    @Binding var triggerScroll: Bool
//    
//    var body: some View {
//        VStack {
//            Spacer()
//            
//            VStack(alignment: .leading, spacing: 8) {
//                SlidersView(value: $opacityShadowText, label: "Opacity", range: 0...100)
//                SlidersView(value: $blurShadowText, label: "Blur", range: 0...20)
//                SlidersView(value: $xShadowText, label: "X", range: -20...20)
//                SlidersView(value: $yShadowText, label: "Y", range: -20...20)
//            }
//            .padding(.leading, 26)
//            .padding(.trailing)
//            .padding(.bottom, 8)
//            
//            ScrollViewReader { proxy in
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack {
//                        ColorPicker("", selection: $colorPickerShadowText, supportsOpacity: false)
//                            .labelsHidden()
//                            .frame(width: 55, height: 55)
//                            .scaleEffect(2)
//                            .onChange(of: colorPickerShadowText) {
//                                colorShadowText = colorPickerShadowText.toHex()
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
//                                        if colorShadowText == hex {
//                                            Circle().stroke(.customRed, lineWidth: 2)
//                                            Image("Selected Color")
//                                        }
//                                    }
//                                }
//                                .id(hex)
//                                .onTapGesture {
//                                    colorShadowText = hex
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
//                    if colorShadowText.hasPrefix("#") {
//                        proxy.scrollTo(colorShadowText, anchor: .center)
//                    }
//                }
//                .onChange(of: triggerScroll) {
//                    if colorShadowText.hasPrefix("#") {
//                        proxy.scrollTo(colorShadowText, anchor: .center)
//                    }
//                }
//                .onChange(of: textBoxViewModel.activeTextBox.id) {
//                    if colorShadowText.hasPrefix("#") {
//                        withAnimation(.easeInOut(duration: 0.2)) {
//                            proxy.scrollTo(colorShadowText, anchor: .center)
//                        }
//                    }
//                }
//            }
//        }
//        .frame(height: 360)
//    }
//}
//
//#Preview {
//    ShadowTextView(
//        textBoxViewModel: TextBoxViewModel(),
//        colorShadowText: .constant("#000000"),
//        opacityShadowText: .constant(100),
//        blurShadowText: .constant(10),
//        xShadowText: .constant(0),
//        yShadowText: .constant(0),
//        triggerScroll: .constant(false)
//    )
//}
