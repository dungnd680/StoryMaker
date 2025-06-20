//
//  Intro2View.swift
//  StoryMaker
//
//  Created by devmacmini on 6/6/25.
//

import SwiftUI

struct Intro2View: View {
    var onNext: () -> Void
    
    var body: some View {
        ZStack {
            Image("Intro 2")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Effect & Filter")
                    .frame(height: 34)
                    .font(.system(size: 28, weight: .semibold))
                
                Text("More than 1000 Tempalte with many topic")
                    .frame(width: 226)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 18, weight: .regular))
                    .padding(.bottom)
                    .padding(.bottom)
                
                Button {
                    onNext()
                } label: {
                    Text("Next")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                        .frame(width: 258, height: 47)
                        .background(.colorRed)
                        .clipShape(RoundedRectangle(cornerRadius: 57))
                        .padding(.vertical)
                }

                Text("Terms of Use  ·  Privacy Policy")
                    .font(.system(size: 12, weight: .light))
            }
            .foregroundStyle(.colorDarkGray)
        }
    }
}

#Preview {
    Intro2View(onNext: {})
}
