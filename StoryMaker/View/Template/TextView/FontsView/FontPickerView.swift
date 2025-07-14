//
//  FontsView.swift
//  StoryMaker
//
//  Created by devmacmini on 11/7/25.
//

import SwiftUI

struct FontPickerView: View {
    
    @ObservedObject var viewModel: FontPickerViewModel
    @ObservedObject var textBoxViewModel: TextBoxViewModel
    
    @Binding var selectedFont: String
    @Binding var showSubscription: Bool
    
    @State private var previousFont: String = ""

    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                ForEach(CFont.categories, id: \.self) { category in
                    if let fonts = viewModel.fontsByCategory[category] {
                        Section(header:
                            Text(category.rawValue)
                                .font(.headline)
                                .foregroundStyle(.colorDarkGray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Color.white)
                        ) {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                                ForEach(fonts, id: \.self) { font in
                                    Button {
                                        previousFont = selectedFont
                                        if font.isPremium {
                                            showSubscription = true
                                        }
                                        selectedFont = font.iosFamily
                                        viewModel.selectedFont = font
                                        textBoxViewModel.activeTextBox.fontFamily = font.iosFamily
                                    } label: {
                                        FontItemView(
                                            content: textBoxViewModel.activeTextBox.content,
                                            font: font,
                                            isSelected: !textBoxViewModel.activeTextBox.fontFamily.isEmpty && font.iosFamily == textBoxViewModel.activeTextBox.fontFamily
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                }
            }
            .padding(.bottom, 100)
        }
        .frame(height: 350)
        .onChange(of: showSubscription) {
            if !showSubscription {
                selectedFont = previousFont
                viewModel.selectedFont = CFont.fonts.first { $0.iosFamily == previousFont } ?? CFont.fonts[0]
            }
        }
    }
}

#Preview {
    FontPickerView(
        viewModel: FontPickerViewModel(),
        textBoxViewModel: TextBoxViewModel(),
        selectedFont: .constant("Aghisna Display"),
        showSubscription: .constant(true)
    )
}
