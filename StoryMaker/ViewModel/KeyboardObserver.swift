//
//  KeyboardObserver.swift
//  StoryMaker
//
//  Created by devmacmini on 8/7/25.
//

import SwiftUI
import Combine

class KeyboardObserver: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    @Published var keyboardAnimation: Animation = .easeOut(duration: 0.25)

    private var cancellables = Set<AnyCancellable>()

    init() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        let willChangeFrame = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

        willShow
            .merge(with: willChangeFrame)
            .sink { [weak self] notification in
                guard let self = self else { return }

                let userInfo = notification.userInfo
                let endFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
                let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
                let curveRaw = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 0

                // Apple dùng rawValue của UIView.AnimationCurve cho curve
                let curve = UIView.AnimationCurve(rawValue: Int(curveRaw)) ?? .easeInOut
                let timing = Self.animation(for: curve, duration: duration)

                withAnimation(timing) {
                    self.keyboardHeight = endFrame.height
                    self.keyboardAnimation = timing
                }
            }
            .store(in: &cancellables)

        willHide
            .sink { [weak self] notification in
                guard let self = self else { return }

                let userInfo = notification.userInfo
                let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25

                let animation = Animation.easeOut(duration: duration)

                withAnimation(animation) {
                    self.keyboardHeight = 0
                    self.keyboardAnimation = animation
                }
            }
            .store(in: &cancellables)
    }

    private static func animation(for curve: UIView.AnimationCurve, duration: Double) -> Animation {
        switch curve {
        case .easeInOut:
            return .easeInOut(duration: duration)
        case .easeIn:
            return .easeIn(duration: duration)
        case .easeOut:
            return .easeOut(duration: duration)
        case .linear:
            return .linear(duration: duration)
        @unknown default:
            return .easeOut(duration: duration)
        }
    }
}
