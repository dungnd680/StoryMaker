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
    
    @Published var backgroundItems: [DataBackground] = []
    
    private var currentRequest: DataRequest?

    func fetchAllBackgrounds() async {
        isLoadingBackground = true
        errorMessage = nil

        do {
            let response = try await AF.request("https://api.fleet-tech.net/story/get_background")
                .validate()
                .serializingDecodable(BackgroundModel.self)
                .value

            self.backgroundModel = response
            self.backgroundItems = response.data
        } catch {
            if (error as? AFError)?.isExplicitlyCancelledError == true {
                print("Request cancelled")
            } else {
                self.errorMessage = "Failed to load: \(error.localizedDescription)"
            }
        }

        isLoadingBackground = false
    }
    
    func cancelRequest() {
        currentRequest?.cancel()
    }
}
