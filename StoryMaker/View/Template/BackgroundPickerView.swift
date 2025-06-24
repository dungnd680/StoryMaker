//
//  BackgroundView.swift
//  StoryMaker
//
//  Created by devmacmini on 24/6/25.
//

import SwiftUI
import Alamofire

struct BackgroundPickerView: View {
    @Environment(\.dismiss) var dismiss
    let onSelect: (UIImage) -> Void
    
    let baseURL = "https://api.fleet-tech.net"

    @StateObject private var viewModel = BackgroundPickerViewModel()
    @State private var selectedURL: String?
    @State private var selectedCategory: CategoryEnum? = nil

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let model = viewModel.backgroundModel {
                    VStack(alignment: .leading, spacing: 0) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(model.config.category, id: \.id) { category in
                                    Text(category.name)
                                        .font(.system(size: 14))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .foregroundColor(
                                            selectedCategory == category.id ? .red : .black
                                        )
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            selectedCategory = category.id
                                        }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }

                        ScrollView {
                            let filteredCategories = selectedCategory == nil ? model.config.category : model.config.category.filter { $0.id == selectedCategory }
                            ForEach(filteredCategories, id: \.id) { category in
                                let items = model.data.filter { $0.category == category.id }
                                if !items.isEmpty {
                                    VStack(alignment: .leading, spacing: 10) {
                                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
                                            ForEach(items, id: \.background) { item in
                                                if let url = URL(string: baseURL + item.thumb) {
                                                    BackgroundItemView(
                                                        url: url,
                                                        isSelected: selectedURL == item.background,
                                                        onTap: {
                                                            selectedURL = item.background
                                                        }
                                                    )
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Background")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        loadSelectedImage()
                    } label: {
                        Image("Selected Done")
                    }
                    .disabled(selectedURL == nil)
                }
            }
        }
        .onAppear {
            viewModel.fetchBackgrounds()
        }
    }

    private func loadSelectedImage() {
        guard let urlString = selectedURL,
              let url = URL(string: baseURL + urlString) else { return }

        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    onSelect(image)
                    dismiss()
                }
            case .failure(let error):
                print("Failed to load image from url:", error)
            }
        }
    }
}

private struct BackgroundItemView: View {
    let url: URL
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                Color.gray.opacity(0.2)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                Color.red
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 66, height: 66)
        .clipped()
        .overlay(
            Rectangle()
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .onTapGesture {
            onTap()
        }
    }
}

//#Preview {
//    BackgroundView()
//}
