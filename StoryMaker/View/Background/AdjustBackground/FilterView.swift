//
//  FiltersView.swift
//  StoryMaker
//
//  Created by devmacmini on 10/7/25.
//

import SwiftUI

struct FilterView: View {
    
    @ObservedObject var filter: Filter
    @ObservedObject var editorVM: EditorVM
    
    let originalImage: UIImage

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Filter.filters, id: \.id) { filters in
                    ZStack {
                        VStack {
                            let thumbnail = editorVM.filteredThumbnails[filters.id] ?? {
                                let generated = Filter.apply(filters.id, to: originalImage)
                                editorVM.filteredThumbnails[filters.id] = generated
                                return generated
                            }()
                            
                            Image(uiImage: thumbnail)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(filter.type == filters.id ? .customRed : .clear, lineWidth: 2)
                                )
                            
                            Text(filters.name)
                                .font(.caption)
                                .foregroundStyle(.customDarkGray)
                        }
                    }
                    .onTapGesture {
                        filter.type = filters.id
                    }
                }
            }
            .padding(.horizontal, 26)
            .padding(.bottom, 22)
            .frame(height: 160)
        }
    }
}

#Preview {
    FilterView(
        filter: Filter(),
        editorVM: EditorVM(),
        originalImage: UIImage(named: "Preview Photo") ?? UIImage()
    )
}
