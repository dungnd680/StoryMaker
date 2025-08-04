//
//  Intro1View.swift
//  StoryMaker
//
//  Created by devmacmini on 5/6/25.
//

import SwiftUI

struct SplashView: View {
    
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false
    
    var onNext: () -> Void
    var onAutoNavigation: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.customOrange, .customRed]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Image("Icon App")
                    .padding(.bottom)
                
                Text("Story Maker")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.bottom, 4)
                
                Text("Use StoryArt to unfold your stories and")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundStyle(.white)
            
            VStack {
                Spacer()
                
                if !hasSeenIntro {
                    Button {
                        onNext()
                    } label: {
                        Text("Get Stared")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundStyle(.customDarkGray)
                            .frame(width: 260, height: 50)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 60))
                    }
                    .padding(.bottom)
                }
                
                Text("Terms of Use  ·  Privacy Policy")
                    .font(.system(size: 12, weight: .light))
                    .foregroundStyle(.white)
            }
        }
        .onAppear {
            if hasSeenIntro {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    onAutoNavigation()
                }
            }
        }
    }
}

#Preview {
    SplashView(onNext: {}, onAutoNavigation: {})
}
