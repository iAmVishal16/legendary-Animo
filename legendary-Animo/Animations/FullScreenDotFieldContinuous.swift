//
//  FullScreenDotFieldContinuous.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 02/10/2025.
//

import SwiftUI
import SpriteKit

struct FullScreenDotFieldContinuous: View {
    var dotSpacing: CGFloat = 24
    var dotRadius: CGFloat = 3.5
    var influenceRadius: CGFloat = 90
    var smoothing: CGFloat = 12
    
    @State private var scene: FullScreenDotFieldContinuousScene?
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if let scene {
                    SpriteView(
                        scene: scene,
                        options: [.allowsTransparency]
                    )
                    .frame(width: proxy.size.width, height: proxy.size.height)
                } else {
                    Color.clear
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        HapticFeedback.gentleImpact()
                        let location = convertToSceneCoordinates(location: value.location, in: proxy.size)
                        scene?.handleDragChanged(to: location)
                    }
                    .onEnded { _ in
                        scene?.handleDragEnded()
                    }
            )
            .onAppear {
                setupScene(size: proxy.size)
            }
            .onChange(of: proxy.size) { newSize in
                scene?.dotSpacing = dotSpacing
                scene?.dotRadius = dotRadius
                scene?.influenceRadius = influenceRadius
                scene?.smoothing = smoothing
                scene?.updateSize(newSize)
            }
        }
    }
    
    private func setupScene(size: CGSize) {
        guard scene == nil else { return }
        let newScene = FullScreenDotFieldContinuousScene()
        newScene.scaleMode = .resizeFill
        newScene.size = size
        newScene.dotSpacing = dotSpacing
        newScene.dotRadius = dotRadius
        newScene.influenceRadius = influenceRadius
        newScene.smoothing = smoothing
        scene = newScene
    }
    
    private func convertToSceneCoordinates(location: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: location.x - size.width / 2,
            y: size.height / 2 - location.y
        )
    }
}

class FullScreenDotFieldContinuousScene: SKScene {
    var dotSpacing: CGFloat = 24
    var dotRadius: CGFloat = 3.5
    var influenceRadius: CGFloat = 90
    var smoothing: CGFloat = 12
    
    private let container = SKNode()
    private var dots: [SKShapeNode] = []
    private var originalPositions: [CGPoint] = []
    private var dragLocation: CGPoint?
    private var lastUpdateTime: TimeInterval = 0
    
    private let gradient: [(angle: CGFloat, color: SKColor)] = [
        (0, SKColor(red: 185/255, green: 88/255, blue: 217/255, alpha: 1)),
        (.pi / 2, SKColor(red: 236/255, green: 103/255, blue: 124/255, alpha: 1)),
        (.pi, SKColor(red: 233/255, green: 188/255, blue: 158/255, alpha: 1)),
        (3 * .pi / 2, SKColor(red: 116/255, green: 190/255, blue: 246/255, alpha: 1)),
        (2 * .pi, SKColor(red: 185/255, green: 88/255, blue: 217/255, alpha: 1))
    ]
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        physicsWorld.gravity = .zero
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        if container.parent == nil {
            addChild(container)
        }
        
        rebuildGrid()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        rebuildGrid()
    }
    
    func updateSize(_ newSize: CGSize) {
        size = newSize
        rebuildGrid()
    }
    
    func handleDragChanged(to location: CGPoint) {
        dragLocation = location
    }
    
    func handleDragEnded() {
        dragLocation = nil
    }
    
    private func rebuildGrid() {
        container.removeAllChildren()
        dots.removeAll()
        originalPositions.removeAll()
        
        guard size.width > 0, size.height > 0 else { return }
        
        let columns = max(Int(ceil(size.width / dotSpacing)), 1) + 1
        let rows = max(Int(ceil(size.height / dotSpacing)), 1) + 1
        let startX = -size.width / 2
        let startY = -size.height / 2
        
        for row in 0..<rows {
            let y = startY + CGFloat(row) * dotSpacing
            for column in 0..<columns {
                let x = startX + CGFloat(column) * dotSpacing
                let position = CGPoint(x: x, y: y)
                let dot = SKShapeNode(circleOfRadius: dotRadius)
                dot.position = position
                dot.fillColor = getColor(for: position)
                dot.strokeColor = .clear
                container.addChild(dot)
                dots.append(dot)
                originalPositions.append(position)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !dots.isEmpty else { return }
        let deltaTime: CGFloat
        if lastUpdateTime == 0 {
            deltaTime = 1 / 60
        } else {
            deltaTime = CGFloat(min(currentTime - lastUpdateTime, 1 / 30))
        }
        lastUpdateTime = currentTime

        let maximumDisplacement = influenceRadius * 0.9
        let radius = influenceRadius
        let radiusSquared = radius * radius
        let factor = min(deltaTime * smoothing, 1)
        
        for (index, dot) in dots.enumerated() {
            let origin = originalPositions[index]
            let target: CGPoint
            if let dragLocation {
                let dx = origin.x - dragLocation.x
                let dy = origin.y - dragLocation.y
                let distanceSquared = dx * dx + dy * dy
                if distanceSquared < radiusSquared {
                    let distance = max(CGFloat(sqrt(distanceSquared)), 0.001)
                    let direction = CGVector(dx: dx / distance, dy: dy / distance)
                    let displacementAmount = (radius - distance) / radius * maximumDisplacement
                    target = CGPoint(
                        x: origin.x + direction.dx * displacementAmount,
                        y: origin.y + direction.dy * displacementAmount
                    )
                } else {
                    target = origin
                }
            } else {
                target = origin
            }
            dot.position = dot.position.interpolated(to: target, factor: factor)
        }
    }
    
    private func getColor(for position: CGPoint) -> SKColor {
        let angle = atan2(position.y, position.x).normalizedToPositiveAngle
        guard let startIndex = gradient.lastIndex(where: { $0.angle <= angle }) else {
            return .white
        }
        let endIndex = min(startIndex + 1, gradient.count - 1)
        let start = gradient[startIndex]
        let end = gradient[endIndex]
        let percent = (angle - start.angle) / (end.angle - start.angle)
        let r = start.color.rgba.red + (end.color.rgba.red - start.color.rgba.red) * percent
        let g = start.color.rgba.green + (end.color.rgba.green - start.color.rgba.green) * percent
        let b = start.color.rgba.blue + (end.color.rgba.blue - start.color.rgba.blue) * percent
        return SKColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

private extension CGPoint {
    func interpolated(to target: CGPoint, factor: CGFloat) -> CGPoint {
        CGPoint(
            x: x + (target.x - x) * factor,
            y: y + (target.y - y) * factor
        )
    }
}

private extension CGFloat {
    var normalizedToPositiveAngle: CGFloat {
        var value = self
        while value < 0 { value += 2 * .pi }
        while value > 2 * .pi { value -= 2 * .pi }
        return value
    }
}

// MARK: - Helpers
private struct HapticFeedback {
    static func gentleImpact() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred(intensity: 0.6)
    }
}

private extension SKColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        #if os(iOS) || os(tvOS)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        #elseif os(macOS)
        self.usingColorSpace(.sRGB)?.getRed(&r, green: &g, blue: &b, alpha: &a)
        #endif
        return (r, g, b, a)
    }
}

#Preview {
    FullScreenDotFieldContinuous()
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
}


