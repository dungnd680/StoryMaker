//
//  BackgroundViewModel.swift
//  StoryMaker
//
//  Created by devmacmini on 24/6/25.
//

import Foundation
import Alamofire

@MainActor
class BackgroundPickerVM: ObservableObject {
    
    @Published var background: Background?
    @Published var isLoadingBackground = false
    @Published var errorMessage: String?
    
    private var currentRequest: DataRequest?

    func fetchAllBackgrounds() async {
        isLoadingBackground = true
        errorMessage = nil

        do {
            let response = try await AF.request("https://api.fleet-tech.net/story/get_background")
                .validate()
                .serializingDecodable(Background.self)
                .value

            self.background = response
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
        print("Cancel Request")
    }
}
