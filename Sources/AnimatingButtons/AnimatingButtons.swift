import SwiftUI

@available(iOS 18.0, macOS 14.0, *)
/// A customizable button with a ripple animation effect.
public struct AnimatingFavoriteButton: View {
    // MARK: - Argument Properties
    /// The action to perform when the button is tapped.
    let action: () -> Void

    // MARK: - Internal Properties
    /// A boolean state indicating whether the button is in the "loved" state. When `true`, the button displays as "loved."
    @State private var isLoved: Bool = false
    /// A boolean state used to control the ripple animation effect. When `true`, the animation is active.
    @State private var isAnimating: Bool = false
    /// An integer representing the count of hearts displayed during the animation. This value can be used to manage or customize the animation effect.
    @State private var heartCount: Int = 0

    // MARK: - Internal Functions
    /// Returns the button's color gradient based on its state.
    /// - Returns: A gradient of pink and red if "loved," or gray otherwise.
    private func loveColor() -> [Color] {
        return isLoved ? [.pink, .red] : [.gray, .gray]
    }

    /// Toggles the button's "loved" state and triggers the ripple animation.
    /// - Activates animation with a spring effect and calls the provided `action` closure.
    /// - Disables the ripple animation after 0.45 seconds with a smooth spring effect.
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

    // MARK: - Public Initializer
    /**
     Initializes a RippleButton with customizable options.

     - Parameters:
        - action: The action to perform when the button is tapped.
     */

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    // MARK: - State Accessor Functions
    public func readState() -> Bool {
        return isLoved
    }

    // MARK: - Body
    public var body: some View {
        Button (action: {
            animateButton()
        }, label: {
            ZStack {
                SplashView()
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1.5 : 0)
                    .animation(.easeInOut(duration: 0.3).delay(0.1), value: isAnimating)

                SplashView()
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1.25 : 0)
                    .animation(.easeInOut(duration: 0.5), value: isAnimating)

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
