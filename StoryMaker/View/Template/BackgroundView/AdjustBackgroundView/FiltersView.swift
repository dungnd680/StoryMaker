//
//  FiltersView.swift
//  StoryMaker
//
//  Created by devmacmini on 10/7/25.
//


import SwiftUI

struct FiltersView: View {
    @Binding var selectedFilter: FiltersModel
    @Binding var filteredThumbnails: [UUID: UIImage]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(filters) { filter in
                    VStack {
                        Image(uiImage: filteredThumbnails[filter.id] ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(selectedFilter.id == filter.id ? Color.red.opacity(0.9) : .clear, lineWidth: 2)
                            )

                        Text(filter.name)
                            .font(.caption)
                            .foregroundColor(selectedFilter.id == filter.id ? .red : .gray)
                    }
                    .onTapGesture {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 22)
            .frame(height: 180)
        }
    }
}