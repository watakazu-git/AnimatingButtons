import SwiftUI

@available(iOS 18.0, macOS 14.0, *)
struct SplashView: View {
    @State private var innerGap = true
    private let streamBlue = Color(#colorLiteral(red: 0, green: 0.3725490196, blue: 1, alpha: 1))

    var body: some View {
        ZStack {
            ForEach(0..<8) {
                Circle()
                    .foregroundStyle(
                        .linearGradient(
                            colors: [.pink, .orange],
                            startPoint: .bottom,
                            endPoint: .leading
                        )
                    )
                    .frame(width: 4, height: 4)
                    .offset(x: innerGap ? 24 : 0)
                    .rotationEffect(.degrees(Double($0) * 45))
//                    .hueRotation(.degrees(300))
            }

            ForEach(0..<8) {
                Circle()
                    .foregroundStyle(
                        .linearGradient(
                            colors: [.pink, .orange],
                            startPoint: .bottom,
                            endPoint: .leading
                        )
                    )
                    .frame(width: 4, height: 4)
                    .offset(x: innerGap ? 26 : 0)
                    .rotationEffect(.degrees(Double($0) * 45))
//                    .hueRotation(.degrees(60))
            }
            .rotationEffect(.degrees(12))
        }
    }
}
