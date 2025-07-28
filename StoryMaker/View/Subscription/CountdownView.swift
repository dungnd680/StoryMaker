//
//  CountdownView.swift
//  StoryMaker
//
//  Created by devmacmini on 10/6/25.
//

import SwiftUI

struct CountdownView: View {
    @AppStorage("countdown") private var targetDate: TimeInterval = 0

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 9)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                .foregroundStyle(.customOrange)
                .frame(width: 250, height: 90)
                .padding(.bottom, 6)

            Text("Hurry Up! Time is running out!")
                .font(.system(size: 16, weight: .semibold))
                .background(.white)
                .foregroundStyle(.customOrange)
                .offset(y: -50)

            TimelineView(.periodic(from: .now, by: 1)) { context in
                let now = context.date.timeIntervalSince1970
                let remaining = max(targetDate - now, 0)
                let hours = Int(remaining) / 3600
                let minutes = (Int(remaining) % 3600) / 60
                let seconds = Int(remaining) % 60

                HStack {
                    timeBox(value: hours, label: "HOUR")
                    Text(":")
                        .font(.system(size: 30, weight: .medium))
                    timeBox(value: minutes, label: "MIN")
                    Text(":")
                        .font(.system(size: 30, weight: .medium))
                    timeBox(value: seconds, label: "SEC")
                }
            }
        }
        .onAppear {
            if targetDate == 0 {
                targetDate = Date().addingTimeInterval(24 * 60 * 60).timeIntervalSince1970
            }
        }
    }

    func timeBox(value: Int, label: String) -> some View {
        VStack {
            Text(String(format: "%02d", value))
                .font(.system(size: 33, weight: .semibold))
                .foregroundStyle(.customGray)
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(.customGray)
        }
        .frame(width: 56, height: 56)
        .background(.customWhiteGray)
        .cornerRadius(7)
    }
}

#Preview {
    CountdownView()
}
