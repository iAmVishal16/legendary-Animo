//
//  ParallaxCarouselView.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 08/11/25.
//

/// Continuous parallax slider in SwiftUI.
import SwiftUI

struct ParallaxCarouselView: View {
    struct CarouselPhoto: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let imageName: String
    }

    private let photos: [CarouselPhoto] = [
        .init(title: "Aurora Peaks", subtitle: "Siberia, Russia", imageName: "image1"),
        .init(title: "Floating Lanterns", subtitle: "Chiang Mai, Thailand", imageName: "image2"),
        .init(title: "Cobalt Shores", subtitle: "Santorini, Greece", imageName: "image3"),
        .init(title: "Standing Tall", subtitle: "Alberta, Canada", imageName: "image4"),
        .init(title: "Golden Hour", subtitle: "Cape Town, South Africa", imageName: "image5"),
        .init(title: "Emerald Mist", subtitle: "Bali, Indonesia", imageName: "image6"),
        .init(title: "City Hues", subtitle: "Tokyo, Japan", imageName: "image1"),
        .init(title: "Palm Skies", subtitle: "Dubai, UAE", imageName: "image2"),
        .init(title: "Velvet Falls", subtitle: "Hồ Chí Minh, Vietnam", imageName: "image3"),
        .init(title: "Neon Nights", subtitle: "New York, USA", imageName: "image4")
    ]

    @State private var rotation: Double = -180
    @State private var dragRotation: Double = 0
    @State private var introRotation: Double = 180
    @State private var didAppear = false
    @State private var activeIndex: Int = 0

    private let dragSensitivity: Double = 0.45

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let cardWidth = min(size.width * 0.72, 320)
            let cardHeight = cardWidth * 1.35
            let radius = min(size.width, size.height) / 2.1
            let perspective = max(size.width, size.height) * 2.0
            let angleStep = 360.0 / Double(photos.count)
            let combinedRotation = rotation + dragRotation

            ZStack {
                LinearGradient(colors: [Color.black, Color(red: 0.02, green: 0.04, blue: 0.08)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                ZStack {
                    ForEach(Array(photos.enumerated()), id: \.offset) { index, photo in
                        let absoluteAngle = introRotation + combinedRotation + angleStep * Double(index)
                        let normalizedAngle = wrapAngle(absoluteAngle)
                        let depth = cos(normalizedAngle * .pi / 180)
                        let focus = max(0, (1 - abs(normalizedAngle) / 110))

                        ParallaxRingCard(
                            photo: photo,
                            index: index,
                            total: photos.count,
                            angle: normalizedAngle,
                            depth: depth,
                            focus: focus,
                            size: CGSize(width: cardWidth, height: cardHeight),
                            radius: radius,
                            perspective: perspective,
                            isReady: didAppear
                        )
                        .zIndex(depth)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .gesture(dragGesture(angleStep: angleStep))
                .onAppear {
                    guard !didAppear else { return }
                    updateActiveIndex(with: rotation, angleStep: angleStep)
                    withAnimation(.easeOut(duration: 1.1)) {
                        introRotation = 0
                    }
                    withAnimation(.spring(response: 1.0, dampingFraction: 0.76).delay(0.25)) {
                        didAppear = true
                    }
                }
                .onChange(of: combinedRotation) { newValue in
                    updateActiveIndex(with: newValue, angleStep: angleStep)
                }

                VStack(alignment: .center, spacing: 12) {
                    Spacer()
                    if photos.indices.contains(activeIndex) {
                        let activePhoto = photos[activeIndex]
                        VStack(spacing: 8) {
                            Text(activePhoto.title)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .tracking(0.8)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.45), radius: 16, x: 0, y: 8)
                                .transition(.opacity.combined(with: .slide))
                            Text(activePhoto.subtitle)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .textCase(.uppercase)
                                .foregroundColor(Color.white.opacity(0.7))
                                .padding(.horizontal, 18)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule(style: .continuous)
                                        .fill(Color.white.opacity(0.08))
                                )
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 28)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .fill(Color.black.opacity(0.35))
                                .blur(radius: 12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.35), radius: 30, y: 16)
                        )
                        .padding(.horizontal, 28)
                        .padding(.bottom, 36)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
            }
        }
    }

    private func dragGesture(angleStep: Double) -> some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                withAnimation(.interactiveSpring(response: 0.28, dampingFraction: 0.82, blendDuration: 0.1)) {
                    dragRotation = Double(value.translation.width) * -dragSensitivity
                }
            }
            .onEnded { value in
                let proposed = rotation + Double(value.translation.width) * -dragSensitivity
                let snapped = snapRotation(proposed, angleStep: angleStep)
                withAnimation(.spring(response: 0.7, dampingFraction: 0.78, blendDuration: 0.15)) {
                    rotation = snapped
                    dragRotation = 0
                }
            }
    }

    private func updateActiveIndex(with rotation: Double, angleStep: Double) {
        let angles = photos.enumerated().map { index, _ in
            wrapAngle(rotation + angleStep * Double(index))
        }

        if let best = angles.enumerated().min(by: { abs($0.element) < abs($1.element) })?.offset,
           best != activeIndex {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.85)) {
                activeIndex = best
            }
        }
    }

    private func snapRotation(_ rotation: Double, angleStep: Double) -> Double {
        wrapAngle(round(rotation / angleStep) * angleStep)
    }
}

private struct ParallaxRingCard: View {
    let photo: ParallaxCarouselView.CarouselPhoto
    let index: Int
    let total: Int
    let angle: Double
    let depth: Double
    let focus: Double
    let size: CGSize
    let radius: CGFloat
    let perspective: CGFloat
    let isReady: Bool

    private var parallaxOffset: CGFloat {
        let normalized = wrap360(angle - 180) / 360.0
        return CGFloat((0.5 - normalized) * size.width * 0.7)
    }

    private var focusScale: CGFloat {
        let depthFactor = CGFloat(max(0, (depth + 1) / 2))
        return 0.72 + 0.28 * depthFactor
    }

    private var focusOpacity: Double {
        isReady ? 0.3 + 0.7 * max(0, (depth + 1) / 2) : 0
    }

    private var blurRadius: CGFloat {
        CGFloat((1 - focus) * 5)
    }

    var body: some View {
        Image(photo.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: size.width * 1.28, height: size.height)
            .clipped()
            .offset(x: parallaxOffset)
            .blur(radius: blurRadius)
            .rotation3DEffect(.degrees(angle), axis: (0, 0, 1))
            .overlay(
                LinearGradient(
                    colors: [
                        .black.opacity(0.0),
                        .black.opacity(0.15),
                        .black.opacity(0.40)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: size.width, height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(Color.white.opacity(0.18 + 0.25 * focus), lineWidth: 1.4)
            )
            .shadow(color: Color.black.opacity(0.5 * (0.5 + depth / 2)), radius: 24, y: 22)
            .scaleEffect(focusScale)
            .opacity(focusOpacity)
            .modifier(ThreeDRingModifier(angle: angle, radius: radius, perspective: perspective))
            .offset(y: isReady ? 0 : 280)
            .accessibilityLabel(Text("Carousel image \(index + 1) of \(total): \(photo.title)"))
    }
}

// Use this Struct to make perspective more cool
private struct ThreeDRingModifier: ViewModifier {
    let angle: Double
    let radius: CGFloat
    let perspective: CGFloat

    func body(content: Content) -> some View {
        let radians = CGFloat(angle * .pi / 120)
        var transform = CATransform3DIdentity
        transform.m34 = -1 / max(perspective, 1)
        transform = CATransform3DTranslate(transform, 0, 0, -radius)
        transform = CATransform3DRotate(transform, radians, 0, 1, 1)
        transform = CATransform3DTranslate(transform, 0, 0, radius)
        return content
            .projectionEffect(ProjectionTransform(transform))
    }
}

private func wrapAngle(_ angle: Double) -> Double {
    var value = angle.truncatingRemainder(dividingBy: 360)
    if value > 180 { value -= 360 }
    if value <= -180 { value += 360 }
    return value
}

private func wrap360(_ angle: Double) -> Double {
    var value = angle.truncatingRemainder(dividingBy: 360)
    if value < 0 { value += 360 }
    return value
}

#Preview {
    ParallaxCarouselView()
        .preferredColorScheme(.dark)
}
