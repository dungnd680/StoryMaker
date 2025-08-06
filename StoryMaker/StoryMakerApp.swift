//
//  StoryMakerApp.swift
//  StoryMaker
//
//  Created by devmacmini on 5/6/25.
//

import SwiftUI

@main
struct StoryMakerApp: App {
    
    init() {
        if let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            print(documentsDir)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
