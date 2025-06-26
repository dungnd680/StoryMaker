//
//  BackgroundViewModel.swift
//  StoryMaker
//
//  Created by devmacmini on 24/6/25.
//

import Foundation
import Alamofire

@MainActor
class BackgroundPickerViewModel: ObservableObject {
    @Published var backgroundModel: BackgroundModel?
    @Published var isLoadingBackground = false
    @Published var errorMessage: String?
    
    @Published var dicBackground: [CategoryEnum: (CategoryData: [DataBackground], isLoaded: Bool, isLoading: Bool)] = [:]
    
    private var currentRequest: DataRequest?

    func fetchCategories() async {
        isLoadingBackground = true
        errorMessage = nil

        do {
            let response = try await AF.request("https://api.fleet-tech.net/story/get_background")
                .validate()
                .serializingDecodable(ConfigOnlyResponse.self)
                .value

            self.backgroundModel = BackgroundModel(config: response.config, data: [])
            print(self.backgroundModel ?? [])

            for category in response.config.category {
                dicBackground[category.id] = (CategoryData: [], isLoaded: false, isLoading: false)
            }
        } catch {
            if (error as? AFError)?.isExplicitlyCancelledError == true {
                print("Request cancelled")
            } else {
                self.errorMessage = "Failed to load: \(error.localizedDescription)"
            }
        }

        isLoadingBackground = false
    }
    
    func fetchBackgrounds(for category: CategoryEnum) async {
        guard var background = dicBackground[category] else { return }

        if background.isLoaded || background.isLoading {
            return
        }

        background.isLoading = true
        dicBackground[category] = background

        do {
            let url = "https://api.fleet-tech.net/story/get_background?cat=\(category)"
            let response = try await AF.request(url)
                .validate()
                .serializingDecodable(BackgroundModel.self)
                .value

            let filtered = response.data
            print("-------------------------------------------------")
            print(filtered)

            dicBackground[category] = (CategoryData: filtered, isLoaded: true, isLoading: false)
        } catch {
            self.errorMessage = "Failed to load background for \(category): \(error.localizedDescription)"
            background.isLoading = false
            dicBackground[category] = background
        }
    }
    
    func cancelRequest() {
        currentRequest?.cancel()
    }
}
