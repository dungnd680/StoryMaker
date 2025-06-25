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
    @State private var selectedURLBackground: String?
    @State private var selectedCategory: CategoryEnum? = nil

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let model = viewModel.backgroundModel {
                    VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(model.config.category, id: \.id) { category in
                                    Text(category.name)
                                        .id(category.id)
                                        .font(.system(size: 14))
                                        .padding(.horizontal, 4)
                                        .foregroundColor(
                                            selectedCategory == category.id ? .red : .black
                                        )
                                        .onTapGesture {
                                            selectedCategory = category.id
                                        }
                                }
                            }
                            .padding()
                        }

                        ScrollView {
                            if let selectedCategory = selectedCategory {
                                let items = model.data.filter { $0.category == selectedCategory }
                                if !items.isEmpty {
                                    VStack {
                                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                                            ForEach(items, id: \.background) { item in
                                                if let url = URL(string: baseURL + item.thumb) {
                                                    BackgroundItemView(
                                                        url: url,
                                                        onTap: {
                                                            loadSelectedImage(with: item.background)
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
                } else if viewModel.errorMessage != nil {
                    VStack {
                        Text("Background loading error!")
                            .opacity(0.2)
                        Button("Try again") {
                            Task {
                                await viewModel.fetchBackgrounds()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Background")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image("Done")
                    }
                }
            }
        }
        .onAppear {
            if viewModel.backgroundModel == nil {
                Task {
                    await viewModel.fetchBackgrounds()
                    if selectedCategory == nil,
                       let firstCategory = viewModel.backgroundModel?.config.category.first?.id {
                        selectedCategory = firstCategory
                    }
                }
            }
        }
        .onDisappear {
            viewModel.cancelRequest()
        }
    }

    private func loadSelectedImage(with path: String) {
        guard let url = URL(string: baseURL + path) else { return }

        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    onSelect(image)
                    dismiss()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Failed to load image from url:", error.localizedDescription)
                }
            }
        }
    }
}

private struct BackgroundItemView: View {
    let url: URL
    let onTap: () -> Void

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty, .failure:
                Color.gray.opacity(0.2)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            @unknown default:
                EmptyView()
            }
        }
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    BackgroundPickerView(onSelect: {_ in })
}
