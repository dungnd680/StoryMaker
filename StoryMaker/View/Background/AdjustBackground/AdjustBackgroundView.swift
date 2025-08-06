//
//  BackgroundFilter.swift
//  StoryMaker
//
//  Created by devmacmini on 1/7/25.
//

import SwiftUI

enum AdjustTab {
    case brightness
    case filters
}

struct AdjustBackgroundView: View {
    
    @State private var selectedTab: AdjustTab = .filters
    
    @ObservedObject var editorVM: EditorVM
    @ObservedObject var filter: Filter
    
    @Binding var lightness: Double
    @Binding var saturation: Double
    @Binding var blur: Double
    @Binding var isVisible: Bool
    
    var tabHeight: [AdjustTab : CGFloat] = [
        .brightness: 280,
        .filters: 240
    ]
    var onClose: () -> Void

    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                ZStack {
                    Text(selectedTab == .brightness ? "Brightness" : "Filters")
                        .font(.headline)
                        .foregroundStyle(.customDarkGray)

                    HStack {
                        Spacer()

                        Image("Done")
                            .padding(.trailing)
                            .onTapGesture {
                                onClose()
                            }
                    }
                }
                .frame(height: 50)

                HStack(spacing: 26) {
                    Button {
                        editorVM.showBackgroundPicker = true
                    } label: {
                        Image("Edit Background")
                    }

                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = .filters
                        }
                    } label: {
                        Image("Filters")
                            .foregroundStyle(selectedTab == .filters ? .customRed : .customDarkGray)
                    }

                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = .brightness
                        }
                    } label: {
                        Image("Brightness")
                            .foregroundStyle(selectedTab == .brightness ? .customRed : .customDarkGray)
                    }
                }
                .padding(.horizontal, 26)
                .frame(height: 30)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 30))

                if selectedTab == .brightness {
                    BrightnessView(
                        lightness: $lightness,
                        saturation: $saturation,
                        blur: $blur
                    )
                }
                
                if selectedTab == .filters {
                    FilterView(
                        filter: filter,
                        editorVM: editorVM,
                        originalImage: editorVM.selectedImage ?? UIImage()
                    )
                }
            }
            .background(Color.white)
        }
        .offset(y:(isVisible ? 0 : tabHeight[selectedTab] ?? 0))
        .animation(.easeInOut(duration: 0.2), value: isVisible)
        .ignoresSafeArea()
        .sheet(isPresented: $editorVM.showBackgroundPicker) {
            BackgroundPickerView { image in
                editorVM.selectedImage = image
            }
        }
    }
}

#Preview {
    AdjustBackgroundView(
        editorVM: EditorVM(),
        filter: Filter(),
        lightness: .constant(0),
        saturation: .constant(0),
        blur: .constant(0),
        isVisible: .constant(true),
        onClose: {}
    )
}
