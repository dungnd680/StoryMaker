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

    @StateObject var bgPickerVM: BackgroundPickerVM = BackgroundPickerVM()
    @StateObject var page: Page = .first()
    
    @State private var selectedURLBackground: String?
    @State private var selectedCategory: CategoryEnum? = nil
    @State private var isRetryLoading = false
    @State private var showCropper = false
    @State private var backgroundImage: UIImage? = nil
    @State private var showLoadBackgroundErrorAlert = false
    
    let onSelect: (UIImage) -> Void
    let baseURL = "https://api.fleet-tech.net"

    var body: some View {
        NavigationStack {
            VStack {
                if bgPickerVM.isLoadingBackground {
                    ProgressView()
                } else if let model = bgPickerVM.background {
                    ScrollViewReader { scrollProxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(model.config.category.enumerated()), id: \.element.id) { index, category in
                                    Text(category.name)
                                        .id(category.id)
                                        .font(.system(size: 14))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 6)
                                        .foregroundColor(selectedCategory == category.id ? .white : .black)
                                        .background(selectedCategory == category.id ? Color.red.opacity(0.8) : Color.clear)
                                        .clipShape(Capsule())
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                selectedCategory = category.id
                                                page.update(.new(index: index))
                                            }
                                        }
                                }
                                .padding(.horizontal, 6)
                            }
                            .padding(.vertical)
                            .onChange(of: selectedCategory) {
                                if let id = selectedCategory {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        scrollProxy.scrollTo(id, anchor: .center)
                                    }
                                }
                            }
                        }
                    }

                    Pager(page: page, data: model.config.category, id: \.id) { category in
                        let items = bgPickerVM.background?.data.filter { $0.category == category.id } ?? []
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                                ForEach(items, id: \.background) { item in
                                    if let url = URL(string: baseURL + item.thumb) {
                                        KFImage(url)
                                            .placeholder {
                                                Color.gray.opacity(0.2)
                                            }
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fill)
                                            .onTapGesture {
                                                loadSelectedImage(with: item.background)
                                            }
                                    }
                                }
                            }
                            .padding(.bottom, 160)
                        }
                    }
                    .itemSpacing(8)
                    .pagingPriority(.simultaneous)
                    .onPageChanged { index in
                        let newCategoryID = model.config.category[index].id
                        selectedCategory = newCategoryID
                    }
                    .animation(.easeInOut(duration: 0.2), value: page.index)
                    .ignoresSafeArea()
                } else if bgPickerVM.errorMessage != nil {
                    if isRetryLoading {
                        ProgressView()
                    } else {
                        VStack {
                            Text("Data download failed.")
                                .padding(.bottom)
                            
                            Button("Retry") {
                                Task {
                                    isRetryLoading = true
                                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                                    await bgPickerVM.fetchAllBackgrounds()
                                    if selectedCategory == nil,
                                       let firstCategory = bgPickerVM.background?.config.category.first?.id {
                                        selectedCategory = firstCategory
                                        if let index = bgPickerVM.background?.config.category.firstIndex(where: { $0.id == firstCategory }) {
                                            page.update(.new(index: index))
                                        }
                                    }
                                    isRetryLoading = false
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .tint(.white)
                            .background(.customOrange)
                            .clipShape(Capsule())
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
            if bgPickerVM.background == nil {
                Task {
                    await bgPickerVM.fetchAllBackgrounds()
                    if selectedCategory == nil,
                       let firstCategory = bgPickerVM.background?.config.category.first?.id {
                        selectedCategory = firstCategory
                        if let index = bgPickerVM.background?.config.category.firstIndex(where: { $0.id == firstCategory }) {
                            page.update(.new(index: index))
                        }
                    }
                }
            }
        }
        .onDisappear {
            bgPickerVM.cancelRequest()
        }
        .onChange(of: backgroundImage) {
            if backgroundImage != nil {
                showCropper = true
            }
        }
        .sheet(isPresented: $showCropper) {
            if let image = backgroundImage {
                ImageCropperView(image: image) { croppedImage in
                    onSelect(croppedImage)
                    dismiss()
                }
            }
        }
        .alert("Download failed", isPresented: $showLoadBackgroundErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please try again.")
        }
    }

    private func loadSelectedImage(with path: String) {
        guard let url = URL(string: baseURL + path) else { return }

        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        backgroundImage = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            backgroundImage = image
                        }
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    showLoadBackgroundErrorAlert = true
                }
            }
        }
    }
}

#Preview {
    BackgroundPickerView(onSelect: {_ in })
}
