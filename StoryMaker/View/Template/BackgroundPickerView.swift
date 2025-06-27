//
//  BackgroundView.swift
//  StoryMaker
//
//  Created by devmacmini on 24/6/25.
//

import SwiftUI
import Alamofire
import SwiftUIPager
import Kingfisher

struct BackgroundPickerView: View {
    @Environment(\.dismiss) var dismiss
    let onSelect: (UIImage) -> Void
    
    let baseURL = "https://api.fleet-tech.net"

    @StateObject private var viewModel = BackgroundPickerViewModel()
    @State private var selectedURLBackground: String?
    @State private var selectedCategory: CategoryEnum? = nil
    @StateObject var page: Page = .first()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoadingBackground {
                    ProgressView()
                } else if let model = viewModel.backgroundModel {
                    VStack {
                        ScrollViewReader { scrollProxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(Array(model.config.category.enumerated()), id: \.element.id) { index, category in
                                        Text(category.name)
                                            .id(category.id)
                                            .font(.system(size: 14))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .foregroundColor(selectedCategory == category.id ? .white : .black)
                                            .background(selectedCategory == category.id ? Color.red.opacity(0.8) : Color.clear)
                                            .clipShape(Capsule())
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
                                .padding(.top)
                                .onChange(of: selectedCategory) {
                                    if let id = selectedCategory {
                                        withAnimation(.spring) {
                                            scrollProxy.scrollTo(id, anchor: .center)
                                        }
                                    }
                                }
                            }
                        }

                        Pager(page: page,
                              data: model.config.category,
                              id: \.id) { category in
                            let items = viewModel.dicBackground[category.id]?.CategoryData ?? []
                            ScrollView(showsIndicators: false) {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                                    ForEach(items, id: \.background) { item in
                                        if let url = URL(string: baseURL + item.thumb),
                                           let bgURL = URL(string: baseURL + item.background) {
                                            KFImage(url)
                                                .placeholder {
                                                    Color.gray.opacity(0.2)
                                                }
                                                .resizable()
                                                .aspectRatio(1, contentMode: .fill)
                                                .onTapGesture {
                                                    loadSelectedImage(with: item.background)
                                                }
                                                .task {
                                                    KingfisherManager.shared.retrieveImage(with: bgURL, options: [.backgroundDecode]) { _ in }
                                                }
                                        }
                                    }
                                }
                                .padding(.horizontal, 4)
                                .padding(.top, 12)
                                .padding(.bottom, 160)
                            }
                        }
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
                        .ignoresSafeArea()
                    }
                } else if viewModel.errorMessage != nil {
                    VStack {
                        Image(systemName: "network.slash")
                            .font(.largeTitle)
                        Text("Network Error!")
                            .padding(.bottom)
                        
                        Button("Retry") {
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
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .tint(.white)
                        .background(.backgroundColor1)
                        .clipShape(Capsule())
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
    }

    private func loadSelectedImage(with path: String) {
        guard let url = URL(string: baseURL + path) else { return }

        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    onSelect(value.image)
                    dismiss()
                }
            case .failure:
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
    }
}

#Preview {
    BackgroundPickerView(onSelect: {_ in })
}
