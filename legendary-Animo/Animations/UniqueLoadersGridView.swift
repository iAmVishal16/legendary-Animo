//
//  UniqueLoadersGridView.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 08/11/25.
//

import SwiftUI

/// A container view that showcases a collection of bespoke loading animations inside a dark themed grid.
struct UniqueLoadersGridView: View {
    private let columns = [GridItem(.adaptive(minimum: 220), spacing: 0, alignment: .center)]

    private let loaderItems: [LoaderItem] = [
        LoaderItem(
            id: "smooth-rotating-dots",
            title: "Smooth Rotating Dots",
            description: "A compact ring of dots that orbit with staggered motion, inspired by CSS keyframe choreography.",
            view: AnyView(SmoothRotatingDotsLoader())
        ),
        LoaderItem(
            id: "jelly-triangle",
            title: "Jelly Triangle",
            description: "Three pulsing nodes breathing in sync while a traveler morphs around the triangle path.",
            view: AnyView(JellyTriangleLoader())
        ),
        LoaderItem(
            id: "typing-cubes",
            title: "Typing Cubes",
            description: "Three cubes pop in sequence to mimic a typing indicator without leaving their lane.",
            view: AnyView(TypingCubesLoader())
        ),
        LoaderItem(
            id: "rainbow-fan",
            title: "Rainbow Fan",
            description: "A rainbow of arcs blooms upward in discrete beats, inspired by masked radial gradients.",
            view: AnyView(RainbowFanLoader())
        ),
        LoaderItem(
            id: "pacman-maze",
            title: "Pac-Man Maze",
            description: "A classic chomper sweeps a neon maze, nibbling dots in a looping chase.",
            view: AnyView(PacmanGameLoader())
        )
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                    .padding(.horizontal)

                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(loaderItems) { item in
                        LoaderTile(item: item)
                    }
                }
                .padding(.horizontal)

            }
//            .padding(32)
        }
        .background(Color.black.ignoresSafeArea())
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Loaders")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white)
                .padding(.vertical, 12)

            Text("Explore meticulously crafted animations rebuilt for SwiftUI. Each tile spotlights a distinct loader with its own story and motion language.")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.8))
        }
    }
}

private struct LoaderTile: View {
    let item: LoaderItem

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            let loaderSide = side * 0.45

            ZStack {
                Color.clear

                item.view
                    .frame(width: loaderSide, height: loaderSide)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                Rectangle()
                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(item.title))
        .accessibilityHint(Text(item.description))
    }
}

private struct LoaderItem: Identifiable {
    let id: String
    let title: String
    let description: String
    let view: AnyView
}

private struct SmoothRotatingDotsLoader: View {
    private let dotCount = 6
    private let size: CGFloat = 120
    private let color: Color = .white
    private let speed: Double = 1.5
    private let containerSpeedMultiplier: Double = 1.8

    private let normalizedPhaseOffsets: [Double] = [
        0.0,
        0.5825,
        0.6660,
        0.7495,
        0.8330,
        0.9165
    ]

    var body: some View {
        GeometryReader { proxy in
            let dimension = min(proxy.size.width, proxy.size.height)
            let dotSize = dimension * 0.17

            TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
                let baseTime = timeline.date.timeIntervalSinceReferenceDate

                let containerProgress = (baseTime / (speed * containerSpeedMultiplier)).normalized

                ZStack {
                    ForEach(0..<dotCount, id: \.self) { index in
                        let phaseOffset = normalizedPhaseOffsets[index]
                        let progress = (baseTime / speed + phaseOffset).normalized
                        let eased = easeInOutSine(progress)
                        let normalizedIndex = dotCount > 1 ? Double(index) / Double(dotCount - 1) : 0
                        let opacity = 1.0 - normalizedIndex * 0.8

                        Circle()
                            .fill(color)
                            .frame(width: dotSize, height: dotSize)
                            .offset(y: -(dimension / 2) + dotSize / 2)
                            .rotationEffect(.degrees(eased * 360))
                            .opacity(opacity)
                    }
                }
                .frame(width: dimension, height: dimension)
                .rotationEffect(.degrees(containerProgress * 360))
            }
        }
        .frame(width: size, height: size)
    }

    private func easeInOutSine(_ t: Double) -> Double {
        0.5 * (1 - cos(.pi * t))
    }
}

private struct JellyTriangleLoader: View {
    private let size: CGFloat = 120
    private let color: Color = .white
    private let speed: Double = 1.75

    private let nodeCenters: [CGPoint] = [
        CGPoint(x: 0.465, y: 0.225),
        CGPoint(x: 0.835, y: 0.775),
        CGPoint(x: 0.165, y: 0.775)
    ]

    private let phaseOffsets: [Double] = [0.0, 1.0 / 3.0, 2.0 / 3.0]

    var body: some View {
        GeometryReader { proxy in
            let dimension = min(proxy.size.width, proxy.size.height)
            let dotSize = dimension * 0.33

            TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
                let baseTime = timeline.date.timeIntervalSinceReferenceDate
                let progress = (baseTime / speed).normalized

                ZStack {
                    ForEach(Array(nodeCenters.enumerated()), id: \.offset) { element in
                        let localProgress = (progress + phaseOffsets[element.offset]).normalized
                        let scale = growScale(for: localProgress)

                        Circle()
                            .fill(color)
                            .frame(width: dotSize, height: dotSize)
                            .scaleEffect(scale)
                            .position(position(for: element.element, dimension: dimension))
                    }

                    Circle()
                        .fill(color)
                        .frame(width: dotSize, height: dotSize)
                        .position(travelerPosition(progress: progress, dimension: dimension))
                }
                .frame(width: dimension, height: dimension)
                .compositingGroup()
                .shadow(color: color.opacity(0.55), radius: dimension * 0.12, x: 0, y: 0)
            }
        }
        .frame(width: size, height: size)
    }

    private func position(for normalizedCenter: CGPoint, dimension: CGFloat) -> CGPoint {
        CGPoint(
            x: normalizedCenter.x * dimension,
            y: normalizedCenter.y * dimension
        )
    }

    private func travelerPosition(progress: Double, dimension: CGFloat) -> CGPoint {
        let cycle = progress * 3
        let segment = Int(floor(cycle)) % nodeCenters.count
        let next = (segment + 1) % nodeCenters.count
        let localT = cycle - floor(cycle)

        let start = nodeCenters[segment]
        let end = nodeCenters[next]

        let interpolated = CGPoint(
            x: start.x + (end.x - start.x) * localT,
            y: start.y + (end.y - start.y) * localT
        )

        return position(for: interpolated, dimension: dimension)
    }

    private func growScale(for progress: Double) -> CGFloat {
        let t = progress

        if t < 0.5 {
            let ratio = t / 0.5
            return CGFloat(1.5 * (1 - ratio))
        } else if t < 0.6 {
            return 0
        } else if t < 0.85 {
            let ratio = (t - 0.6) / (0.85 - 0.6)
            return CGFloat(1.5 * ratio)
        } else {
            return 1.5
        }
    }
}

private struct TypingCubesLoader: View {
    private let cubeCount = 3
    private let size: CGFloat = 120
    private let color: Color = .white
    private let speed: Double = 1.2

    private let phaseOffsets: [Double] = [0.0, 0.2, 0.4]
    private let jumpHeightFactor: CGFloat = 0.75

    private struct Keyframe {
        let time: Double
        let scaleX: Double
        let scaleY: Double
    }

    private let keyframes: [Keyframe] = [
        Keyframe(time: 0.0, scaleX: 0.65, scaleY: 1.3),
        Keyframe(time: 0.18, scaleX: 1.45, scaleY: 0.95),
        Keyframe(time: 0.35, scaleX: 1.0, scaleY: 1.0),
        Keyframe(time: 0.5, scaleX: 0.9, scaleY: 1.05),
        Keyframe(time: 0.68, scaleX: 0.8, scaleY: 1.2),
        Keyframe(time: 0.85, scaleX: 0.9, scaleY: 1.05),
        Keyframe(time: 1.0, scaleX: 0.65, scaleY: 1.3)
    ]

    var body: some View {
        GeometryReader { proxy in
            let dimension = min(proxy.size.width, proxy.size.height)
            let cubeSize = dimension * 0.24
            let spacing = cubeSize * 0.35

            TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
                let baseTime = timeline.date.timeIntervalSinceReferenceDate
                let progress = (baseTime / speed).normalized

                ZStack {
                    Color.clear

                    HStack(spacing: spacing) {
                        ForEach(0..<cubeCount, id: \.self) { index in
                            let localProgress = (progress + phaseOffsets[index]).normalized
                            let scale = cubeScale(for: localProgress)
                            let offset = cubeOffset(for: localProgress, cubeSize: cubeSize)

                            cubeShape(cubeSize: cubeSize, scale: scale, offset: offset)
                        }
                    }
                    .frame(
                        width: (cubeSize * CGFloat(cubeCount)) + spacing * CGFloat(cubeCount - 1),
                        height: cubeSize * 2,
                        alignment: .bottom
                    )
                }
                .frame(width: dimension, height: dimension, alignment: .center)
            }
        }
        .frame(width: size, height: size)
    }

    private func cubeShape(cubeSize: CGFloat, scale: CGSize, offset: CGFloat) -> some View {
        let base = RoundedRectangle(cornerRadius: cubeSize * 0.25, style: .continuous)
            .fill(color)
            .frame(width: cubeSize, height: cubeSize)
            .scaleEffect(x: scale.width, y: scale.height, anchor: .bottom)
            .shadow(color: color.opacity(0.45), radius: cubeSize * 0.45, x: 0, y: cubeSize * 0.12)

        let reflection = base
            .scaleEffect(y: -5, anchor: .top)
            .opacity(0.28)
            .blur(radius: cubeSize * 0.08)
            .mask(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .white.opacity(0.6), location: 0),
                        .init(color: .clear, location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

        return VStack(spacing: cubeSize * 0.08) {
            base
                .offset(y: -offset)
            reflection
        }
        .frame(width: cubeSize, height: cubeSize * 2, alignment: .bottom)
    }

    private func cubeScale(for progress: Double) -> CGSize {
        let wrapped = progress.normalized

        guard let first = keyframes.first else {
            return CGSize(width: 1, height: 1)
        }

        if wrapped <= first.time {
            return CGSize(width: CGFloat(first.scaleX), height: CGFloat(first.scaleY))
        }

        for index in 0..<(keyframes.count - 1) {
            let current = keyframes[index]
            let next = keyframes[index + 1]

            if wrapped <= next.time {
                let range = max(next.time - current.time, .leastNonzeroMagnitude)
                let segmentProgress = (wrapped - current.time) / range

                let scaleX = current.scaleX + (next.scaleX - current.scaleX) * segmentProgress
                let scaleY = current.scaleY + (next.scaleY - current.scaleY) * segmentProgress

                return CGSize(width: CGFloat(scaleX), height: CGFloat(scaleY))
            }
        }

        if let last = keyframes.last {
            return CGSize(width: CGFloat(last.scaleX), height: CGFloat(last.scaleY))
        }

        return CGSize(width: 1, height: 1)
    }

    private func cubeOffset(for progress: Double, cubeSize: CGFloat) -> CGFloat {
        let wave = sin(progress * .pi)
        let eased = pow(max(0, wave), 1.4)
        return cubeSize * jumpHeightFactor * eased
    }
}

private struct RainbowFanLoader: View {
    private let width: CGFloat = 120
    private let height: CGFloat = 60
    private let stepCount: Int = 6
    private let speed: Double = 2.0
    private let rainbowColors: [Color] = [
        Color(red: 0.94, green: 0.27, blue: 0.27),
        Color(red: 0.99, green: 0.59, blue: 0.16),
        Color(red: 0.99, green: 0.87, blue: 0.20),
        Color(red: 0.40, green: 0.74, blue: 0.39),
        Color(red: 0.27, green: 0.58, blue: 0.85),
        Color(red: 0.55, green: 0.35, blue: 0.79)
    ]

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
            let baseTime = timeline.date.timeIntervalSinceReferenceDate
            let progress = (baseTime / speed).normalized
            let activeSteps = min(stepCount, Int(progress * Double(stepCount + 1)))

            Canvas { context, size in
                let width = size.width
                let height = size.height
                let radius = width / 2
                let center = CGPoint(x: width / 2, y: height)
                guard activeSteps > 0 else { return }

                let ringThickness = radius / CGFloat(stepCount)
                let spacing = ringThickness * 0.2

                for index in 0..<activeSteps {
                    let outerRadius = radius - CGFloat(stepCount - index - 1) * ringThickness
                    let innerRadius = max(0, outerRadius - (ringThickness - spacing))
                    let color = rainbowColors[index % rainbowColors.count]

                    var path = Path()
                    path.addArc(center: center, radius: outerRadius, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)

                    if innerRadius > 0 {
                        path.addArc(center: center, radius: innerRadius, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: true)
                    } else {
                        path.addLine(to: center)
                    }

                    path.closeSubpath()
                    context.fill(path, with: .color(color))
                }
            }
        }
        .frame(width: width, height: height)
        .clipShape(
            RoundedRectangle(cornerRadius: height, style: .continuous)
        )
    }
}

private struct PacmanGameLoader: View {
    private let size: CGFloat = 120
    private let speed: Double = 3.0
    private let pacmanColor = Color.red
    private let wallColor = Color.white.opacity(0.15)
    private let dotColor = Color.white

    private struct Segment {
        let start: CGPoint
        let end: CGPoint
        let length: Double
    }

    private struct DotState: Identifiable {
        let id: Int
        let position: CGPoint
        let opacity: Double
    }

    private let pathPoints: [CGPoint]
    private let segments: [Segment]
    private let totalLength: Double
    private let dotProgressValues: [Double]

    init() {
        let points: [CGPoint] = [
            CGPoint(x: 0.12, y: 0.20),
            CGPoint(x: 0.88, y: 0.20),
            CGPoint(x: 0.88, y: 0.40),
            CGPoint(x: 0.12, y: 0.40),
            CGPoint(x: 0.12, y: 0.60),
            CGPoint(x: 0.88, y: 0.60),
            CGPoint(x: 0.88, y: 0.80),
            CGPoint(x: 0.12, y: 0.80),
            CGPoint(x: 0.12, y: 0.20)
        ]
        self.pathPoints = points

        var builtSegments: [Segment] = []
        for index in 0..<(points.count - 1) {
            let start = points[index]
            let end = points[index + 1]
            let dx = Double(end.x - start.x)
            let dy = Double(end.y - start.y)
            let length = sqrt(dx * dx + dy * dy)
            builtSegments.append(Segment(start: start, end: end, length: length))
        }
        self.segments = builtSegments
        self.totalLength = builtSegments.reduce(0) { $0 + $1.length }

        self.dotProgressValues = stride(from: 0.05, through: 0.95, by: 0.08).map { min($0, 0.98) }
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
            let baseTime = timeline.date.timeIntervalSinceReferenceDate
            let progress = (baseTime / speed).normalized
            let mouth = pacmanMouth(for: baseTime)

            GeometryReader { proxy in
                let dimension = min(proxy.size.width, proxy.size.height)
                let pacmanSize = dimension * 0.22
                let (position, angle) = pacmanTransform(for: progress, dimension: dimension)
                let dots = dotStates(for: progress, dimension: dimension)

                ZStack {
                    mazePath(in: dimension)
                        .stroke(style: StrokeStyle(lineWidth: dimension * 0.04, lineCap: .round))
                        .foregroundStyle(wallColor)

                    ForEach(dots) { dot in
                        Circle()
                            .fill(dotColor)
                            .frame(width: dimension * 0.08, height: dimension * 0.08)
                            .position(dot.position)
                            .opacity(dot.opacity)
                    }

                    PacmanShape(mouthAngle: mouth)
                        .fill(pacmanColor)
                        .frame(width: pacmanSize, height: pacmanSize)
                        .shadow(color: Color.black.opacity(0.25), radius: pacmanSize * 0.4, x: 0, y: pacmanSize * 0.15)
                        .overlay(
                            Circle()
                                .fill(Color.black.opacity(0.75))
                                .frame(width: pacmanSize * 0.12, height: pacmanSize * 0.12)
                                .offset(x: pacmanSize * 0.12, y: -pacmanSize * 0.18)
                        )
                        .rotationEffect(angle)
                        .position(position)
                }
                .frame(width: dimension, height: dimension)
            }
        }
        .frame(width: size, height: size)
    }

    private func pacmanMouth(for time: Double) -> Double {
        let wave = (sin(time * .pi * 4) + 1) * 0.5
        return 30 + wave * 40
    }

    private func pacmanTransform(for progress: Double, dimension: CGFloat) -> (position: CGPoint, angle: Angle) {
        let wrapped = progress.normalized
        var distance = wrapped * totalLength
        var segmentIndex = 0

        while segmentIndex < segments.count && distance > segments[segmentIndex].length {
            distance -= segments[segmentIndex].length
            segmentIndex += 1
        }

        let segment = segments[min(segmentIndex, segments.count - 1)]
        let localProgress = segment.length > 0 ? distance / segment.length : 0

        let start = segment.start
        let end = segment.end

        let x = start.x + CGFloat(localProgress) * (end.x - start.x)
        let y = start.y + CGFloat(localProgress) * (end.y - start.y)

        let dx = Double(end.x - start.x)
        let dy = Double(end.y - start.y)
        let angle = Angle(radians: atan2(dy, dx))

        return (
            CGPoint(x: x * dimension, y: y * dimension),
            angle
        )
    }

    private func dotStates(for progress: Double, dimension: CGFloat) -> [DotState] {
        dotProgressValues.enumerated().map { index, dotProgress in
            let position = pacmanTransform(for: dotProgress, dimension: dimension).position
            let diff = progress - dotProgress
            let opacity: Double
            if diff <= 0 {
                opacity = 1.0
            } else {
                let fade = min(1.0, max(0.0, diff / 0.12))
                opacity = 1.0 - fade * 0.8
            }
            return DotState(id: index, position: position, opacity: max(opacity, 0.2))
        }
    }

    private func mazePath(in dimension: CGFloat) -> Path {
        var path = Path()
        let scaled = pathPoints.map { CGPoint(x: $0.x * dimension, y: $0.y * dimension) }

        path.move(to: scaled.first!)
        for point in scaled.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()

        let midX = dimension * 0.5
        path.move(to: CGPoint(x: midX, y: dimension * 0.20))
        path.addLine(to: CGPoint(x: midX, y: dimension * 0.80))

        let horizontalOffset: CGFloat = dimension * 0.32
        path.move(to: CGPoint(x: dimension * 0.12, y: dimension * 0.50))
        path.addLine(to: CGPoint(x: dimension * 0.88, y: dimension * 0.50))

        path.move(to: CGPoint(x: dimension * 0.12, y: dimension * 0.30))
        path.addLine(to: CGPoint(x: midX - horizontalOffset, y: dimension * 0.30))
        path.move(to: CGPoint(x: midX + horizontalOffset, y: dimension * 0.30))
        path.addLine(to: CGPoint(x: dimension * 0.88, y: dimension * 0.30))

        path.move(to: CGPoint(x: dimension * 0.12, y: dimension * 0.70))
        path.addLine(to: CGPoint(x: midX - horizontalOffset, y: dimension * 0.70))
        path.move(to: CGPoint(x: midX + horizontalOffset, y: dimension * 0.70))
        path.addLine(to: CGPoint(x: dimension * 0.88, y: dimension * 0.70))

        return path
    }
}

private struct PacmanShape: Shape {
    var mouthAngle: Double

    var animatableData: Double {
        get { mouthAngle }
        set { mouthAngle = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startAngle = Angle(degrees: mouthAngle / 2)
        let endAngle = Angle(degrees: 360 - mouthAngle / 2)

        var path = Path()
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        return path
    }
}

private extension Double {
    var normalized: Double {
        var value = self
        value.formTruncatingRemainder(dividingBy: 1)
        if value < 0 { value += 1 }
        return value
    }
}

struct UniqueLoadersGridView_Previews: PreviewProvider {
    static var previews: some View {
        UniqueLoadersGridView()
    }
}

