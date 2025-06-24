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
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchBackgrounds() {
        isLoading = true
        errorMessage = nil

        AF.request("https://api.fleet-tech.net/story/get_background")
            .validate()
            .responseDecodable(of: BackgroundModel.self) { [weak self] response in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let model):
                        self.backgroundModel = model
                    case .failure(let error):
                        self.errorMessage = "Failed to load: \(error.localizedDescription)"
                        print("API Error:", error)
                    }
                }
            }
    }
}
