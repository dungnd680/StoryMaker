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
    
    private var currentRequest: DataRequest?

    func fetchBackgrounds() async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await AF.request("https://api.fleet-tech.net/story/get_background")
                .validate()
                .serializingDecodable(BackgroundModel.self)
                .value

            self.backgroundModel = response
        } catch {
            if (error as? AFError)?.isExplicitlyCancelledError == true {
                print("Request cancelled")
            } else {
                self.errorMessage = "Failed to load: \(error.localizedDescription)"
            }
        }

        isLoading = false
    }
    
    func cancelRequest() {
        currentRequest?.cancel()
    }
}
