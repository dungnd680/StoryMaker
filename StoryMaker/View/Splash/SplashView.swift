//
//  Intro1View.swift
//  StoryMaker
//
//  Created by devmacmini on 5/6/25.
//

import SwiftUI

struct SplashView: View {
    /*
     ~ Khai báo biến onNext, kiểu là một hàm không có tham số và không trả về giá trị (Void)
     ~ Dùng khi muốn truyền một hành động từ bên ngoài vào View
     ~ Khi bấm nút, onNext() sẽ được gọi và logic cụ thể sẽ được định nghĩa từ bên ngoài
     */
    var onNext: () -> Void
    var onAutoNavigation: () -> Void
    
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.backgroundColor1, .backgroundColor2]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Image("Icon App")
                    .padding(.bottom)
                
                Text("Story Maker")
                    .font(.system(size: 28, weight: .bold))
                
                Text("Use StoryArt unfold your stories and")
                    .font(.system(size: 15, weight: .medium))
            }
            .foregroundStyle(.white)
            
            VStack {
                Spacer()
                
                if !hasSeenIntro {
                    Button {
                        onNext()
                    } label: {
                        Text("Get Stared")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.black)
                            .frame(width: 258, height: 47)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 57))
                            .padding(.bottom)
                    }
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
