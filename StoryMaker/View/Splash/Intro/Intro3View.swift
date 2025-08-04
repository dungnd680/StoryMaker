//
//  Intro3View.swift
//  StoryMaker
//
//  Created by devmacmini on 6/6/25.
//

import SwiftUI

struct Intro3View: View {
    
    var onNext: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("Intro 3")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Text Art")
                    .font(.system(size: 30, weight: .semibold))
                    .frame(height: 30)
                
                Text("More than 1000 Tempalte with many topic")
                    .font(.system(size: 20, weight: .regular))
                    .multilineTextAlignment(.center)
                    .frame(width: 230)
                    .padding(.bottom, 32)
                
                Button {
                    onNext()
                } label: {
                    Text("Next")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .frame(width: 260, height: 50)
                        .background(.customRed)
                        .clipShape(RoundedRectangle(cornerRadius: 60))
                }
                .padding(.vertical)

                Text("Terms of Use  ·  Privacy Policy")
                    .font(.system(size: 12, weight: .light))
            }
            .foregroundStyle(.customDarkGray)
        }
    }
}

#Preview {
    Intro3View(onNext: {})
}
