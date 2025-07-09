//
//  ContentView.swift
//  StoryMaker
//
//  Created by devmacmini on 5/6/25.
//

import SwiftUI

enum AppScreen {
    case splash
    case intro1
    case intro2
    case intro3
    case intro4
    case template
}

struct ContentView: View {
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false
    
    @State private var currentScreen: AppScreen = .splash
    
//    init() {
//        #if DEBUG
//        UserDefaults.standard.removeObject(forKey: "hasSeenIntro")
//        UserDefaults.standard.removeObject(forKey: "hideSubscription")
//        #endif
//    }
    
    var body: some View {
        ZStack {
            switch currentScreen {
            case .splash:
                SplashView(
                    onNext: { currentScreen = .intro1 },
                    onAutoNavigation: { currentScreen = .template }
                )
                .transition(.opacity)
                
            case .intro1:
                Intro1View(onNext: {
                    currentScreen = .intro2
                })
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
                
            case .intro2:
                Intro2View(onNext: {
                    currentScreen = .intro3
                })
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
                
            case .intro3:
                Intro3View(onNext: {
                    currentScreen = .intro4
                })
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
                
            case .intro4:
                Intro4View(onNext: {
                    hasSeenIntro = true
                    currentScreen = .template
                })
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))
                
            case .template:
                TemplateView()
                    .transition(.opacity)
            }
        }
        .animation(.spring, value: currentScreen)
    }
}

#Preview {
    ContentView()
}
