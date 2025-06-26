//
//  BackgroundView.swift
//  StoryMaker
//
//  Created by devmacmini on 24/6/25.
//

import SwiftUI
import Alamofire
import SwiftUIPager

struct BackgroundPickerView: View {
    @Environment(\.dismiss) var dismiss
    let onSelect: (UIImage) -> Void
    
    let baseURL = "https://api.fleet-tech.net"

    @StateObject private var viewModel = BackgroundPickerViewModel()
    @State private var selectedURLBackground: String?
    @State private var selectedCategory: CategoryEnum? = nil
    @StateObject var page: Page = .first()
    @State private var selectedUIImage: UIImage? = nil
    @State private var showCropper = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoadingBackground {
                    ProgressView()
                } else if let model = viewModel.backgroundModel {
                    VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(model.config.category.enumerated()), id: \.element.id) { index, category in
                                    Text(category.name)
                                        .id(category.id)
                                        .font(.system(size: 14))
                                        .padding(.horizontal, 4)
                                        .foregroundColor(
                                            selectedCategory == category.id ? .red : .black
                                        )
                                        .onTapGesture {
                                            selectedCategory = category.id
                                            page.update(.new(index: index))
                                            let isLoaded = viewModel.dicBackground[category.id]?.isLoaded ?? false
                                            if isLoaded == false {
                                                Task {
                                                    await viewModel.fetchBackgrounds(for: category.id)
                                                }
                                            }
                                        }
                                }
                            }
                            .padding()
                        }

                        if let model = viewModel.backgroundModel {
                            CategoryPagerView(
                                model: model,
                                dicBG: viewModel.dicBackground,
                                baseURL: baseURL,
                                page: page,
                                onSelectImage: loadSelectedImage,
                                selectedCategory: $selectedCategory,
                                viewModel: viewModel
                            )
                        }
                    }
                } else if viewModel.errorMessage != nil {
                    VStack {
                        Text("Network Error!")
                            .opacity(0.2)
                        Button("Try again") {
                            Task {
                                await viewModel.fetchCategories()
                                if selectedCategory == nil,
                                   let firstCategory = viewModel.backgroundModel?.config.category.first?.id {
                                    selectedCategory = firstCategory
                                    if let index = viewModel.backgroundModel?.config.category.firstIndex(where: { $0.id == firstCategory }) {
                                        page.update(.new(index: index))
                                    }
                                    await viewModel.fetchBackgrounds(for: firstCategory)
                                }
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
                    await viewModel.fetchCategories()
                    if selectedCategory == nil,
                       let firstCategory = viewModel.backgroundModel?.config.category.first?.id {
                        selectedCategory = firstCategory
                        if let index = viewModel.backgroundModel?.config.category.firstIndex(where: { $0.id == firstCategory }) {
                            page.update(.new(index: index))
                        }
                        await viewModel.fetchBackgrounds(for: firstCategory)
                    }
                }
            }
        }
        .onDisappear {
            viewModel.cancelRequest()
        }
        .fullScreenCover(isPresented: $showCropper) {
            if let image = selectedUIImage {
                ImageCropperView(
                    image: image,
                    onCrop: { croppedImage in
                        onSelect(croppedImage)
                        dismiss()
                    },
                    onCancel: {
                        showCropper = false
                    }
                )
            }
        }
    }

    private func loadSelectedImage(with path: String) {
        guard let url = URL(string: baseURL + path) else { return }

        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    selectedUIImage = image
                    showCropper = true
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Failed to load image from url:", error.localizedDescription)
                }
            }
        }
    }
}

struct CategoryPagerView: View {
    let model: BackgroundModel
    let dicBG: [CategoryEnum: (CategoryData: [DataBackground], isLoaded: Bool, isLoading: Bool)]
    let baseURL: String
    @ObservedObject var page: Page
    let onSelectImage: (String) -> Void
    @Binding var selectedCategory: CategoryEnum?
    let viewModel: BackgroundPickerViewModel

    var body: some View {
        Pager(page: page,
              data: model.config.category,
              id: \.id) { category in
            let items = dicBG[category.id]?.CategoryData ?? []
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                    ForEach(items, id: \.background) { item in
                        if let url = URL(string: baseURL + item.thumb) {
                            BackgroundItemView(
                                url: url,
                                onTap: {
                                    onSelectImage(item.background)
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .tag(category.id)
        }
        .padding(.top)
        .onPageChanged { index in
            let newCategoryID = model.config.category[index].id
            selectedCategory = newCategoryID
            let isLoaded = viewModel.dicBackground[newCategoryID]?.isLoaded ?? false
            if isLoaded == false {
                Task {
                    await viewModel.fetchBackgrounds(for: newCategoryID)
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
        .frame(width: 110, height: 110)
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    BackgroundPickerView(onSelect: {_ in })
}
