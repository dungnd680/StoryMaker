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
                gradient: Gradient(colors: [.customOrange, .customRed]),
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
                    .padding(.bottom, 6)
                
                (
                    Text("Get unlimited access to all premium features. ")
                        .foregroundStyle(.customDarkGray)
                    +
                    Text("Cancel anytime")
                        .foregroundStyle(.customOrange)
                )
                .font(.system(size: 16))
                .frame(width: 260)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
                
                Text("15.8$ per week")
                    .font(.system(size: 18))
                    .strikethrough()
                    .foregroundStyle(.customLightGray)
                
                (
                    Text("3.9$")
                        .font(.system(size: 33, weight: .bold))
                    +
                    Text("per week")
                        .font(.system(size: 20, weight: .bold))
                )
                .foregroundStyle(.customGreen)
                
                Button {
                    
                } label: {
                    HStack {
                        Text("Payment now")
                            .foregroundStyle(.white)
                        Image("Arrowshape Right")
                    }
                    .frame(width: 260, height: 50)
                    .background(.customGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 60))
                }
                
                Button {
                    
                } label: {
                    Text("Auto-renewable")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.customDarkGray)
                }
                .padding(.vertical)
                
                Text("Terms of Use  ·  Privacy Policy")
                    .font(.system(size: 12, weight: .light))
                    .foregroundStyle(.customGray2)
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image("Xmark Circle")
                    }
                    .padding(.trailing)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    SubscriptionView()
}
