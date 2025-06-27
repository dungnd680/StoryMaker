//
//  SubbscriptionView.swift
//  StoryMaker
//
//  Created by devmacmini on 9/6/25.
//

import SwiftUI

struct SubscriptionView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.backgroundColor2, .backgroundColor1]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea()
            
            Image("Subscription")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                CountdownView()
                
                (
                    Text("Get unlimited access to all premium features. ")
                        .foregroundStyle(.colorDarkGray)
                    +
                    Text("Cancel anytime")
                        .foregroundStyle(.colorOrange)
                )
                .frame(width: 260)
                .multilineTextAlignment(.center)
                .font(.system(size: 16))
                .padding(.bottom)
                
                Text("15.8$ per week")
                    .font(.system(size: 18))
                    .strikethrough()
                    .foregroundStyle(.colorLightGray)
                
                (
                    Text("3.9$")
                        .font(.system(size: 33, weight: .bold))
                    +
                    Text("per week")
                        .font(.system(size: 20, weight: .bold))
                )
                .foregroundStyle(.colorGreen)
                
                Button {
                    
                } label: {
                    HStack {
                        Text("Payment now")
                            .foregroundStyle(.white)
                        Image("Arrowshape Right")
                    }
                    .frame(width: 256, height: 50)
                    .background(.colorGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 60))
                    .padding(.bottom)
                }
                
                Button {
                    
                } label: {
                    Text("Auto-renewable")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.colorDarkGray)
                        .padding(.bottom)
                }
                
                Text("Terms of Use  ·  Privacy Policy")
                    .font(.system(size: 12, weight: .light))
                    .foregroundStyle(.colorLightGray)
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image("Xmark Circle")
                            .padding(.trailing)
                    }
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    SubscriptionView()
}
