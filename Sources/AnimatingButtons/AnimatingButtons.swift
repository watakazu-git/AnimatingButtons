import SwiftUI

@available(iOS 18.0, macOS 14.0, *)
public struct AnimatingFavoriteButton: View {
    // MARK: - Argument Properties
    let action: () -> Void

    // MARK: - Internal Properties
    @State private var isLoved: Bool = false
    @State private var isAnimating: Bool = false
    @State private var heartCount: Int = 0

    private func loveColor() -> [Color] {
        return isLoved ? [.pink, .red] : [.gray, .gray]
    }

    private func animateButton() {
        heartCount += 1

        withAnimation(.interpolatingSpring(stiffness: 170, damping: 5)) {
            isLoved.toggle()

            if heartCount % 2 == 1 {
                isAnimating.toggle()
                action()
            }
        }

        Task {
            try await Task.sleep(nanoseconds: 450_000_000) // 0.45s
            withAnimation(.interpolatingSpring(stiffness: 170, damping: 10)) {
                isAnimating = false
            }
        }
    }

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button (action: {
            animateButton()
        }, label: {
            ZStack {
                SplashView()
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1.25 : 0)
                    .animation(.easeInOut(duration: 0.5), value: isAnimating)

                SplashView()
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1.5 : 0)
                    .animation(.easeInOut(duration: 0.3).delay(0.1), value: isAnimating)

                // TODO: Add disappear effect

                Image(systemName: "heart.fill")
                    .phaseAnimator([false, true], trigger: heartCount) { icon, scaleFromBottom in
                        icon
                            .scaleEffect(scaleFromBottom ? 1.5 : 1, anchor: .bottom)
                    } animation: { scaleFromBottom in
                            .bouncy(duration: 0.4, extraBounce: 0.4)
                    }

                Image(systemName: "heart.fill")
                    .foregroundStyle(
                        .linearGradient(
                            colors: loveColor(),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .phaseAnimator([false, true], trigger: heartCount) { icon, scaleFromBottom in
                        icon
                            .scaleEffect(scaleFromBottom ? 1.5 : 1, anchor: .bottom)
                    } animation: { scaleFromBottom in
                            .bouncy(duration: 0.4, extraBounce: 0.4)
                    }

                // TODO: Add Keyframe Animation
            }
        })
    }
}
