//
//  FontPickerViewModel.swift
//  StoryMaker
//
//  Created by devmacmini on 11/7/25.
//

import Foundation

class FontPickerViewModel: ObservableObject {
    @Published var selectedFont: CFont = CFont.fonts.first!
    let fontsByCategory: [FontCategory: [CFont]]

    init() {
        var dict = [FontCategory: [CFont]]()
        for category in CFont.categories {
            dict[category] = CFont.fonts.filter { $0.category == category }
        }
        self.fontsByCategory = dict
    }
}
