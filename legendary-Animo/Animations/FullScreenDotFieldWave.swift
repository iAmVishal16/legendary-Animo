//
//  FullScreenDotFieldWave.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 04/10/2025.
//

import SwiftUI
import SpriteKit

struct FullScreenDotFieldWave: View {
    var dotSpacing: CGFloat = 20
    var dotRadius: CGFloat = 3.5
    var influenceRadius: CGFloat = 170
    var stiffness: CGFloat = 16
    var damping: CGFloat = 6
    var waveForce: CGFloat = 5200
    
    @State private var scene: FullScreenDotFieldWaveScene?
    
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
                        HapticFeedback.waveImpact()
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
                scene?.stiffness = stiffness
                scene?.damping = damping
                scene?.waveForce = waveForce
                scene?.updateSize(newSize)
            }
        }
    }
    
    private func setupScene(size: CGSize) {
        guard scene == nil else { return }
        let newScene = FullScreenDotFieldWaveScene()
        newScene.scaleMode = .resizeFill
        newScene.size = size
        newScene.dotSpacing = dotSpacing
        newScene.dotRadius = dotRadius
        newScene.influenceRadius = influenceRadius
        newScene.stiffness = stiffness
        newScene.damping = damping
        newScene.waveForce = waveForce
        scene = newScene
    }
    
    private func convertToSceneCoordinates(location: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: location.x - size.width / 2,
            y: size.height / 2 - location.y
        )
    }
}

class FullScreenDotFieldWaveScene: SKScene {
    var dotSpacing: CGFloat = 20
    var dotRadius: CGFloat = 3.5
    var influenceRadius: CGFloat = 170
    var stiffness: CGFloat = 16
    var damping: CGFloat = 6
    var waveForce: CGFloat = 5200
    
    private let container = SKNode()
    private var dots: [SKShapeNode] = []
    private var originalPositions: [CGPoint] = []
    private var displacements: [CGVector] = []
    private var velocities: [CGVector] = []
    private var dragLocation: CGPoint?
    private var previousDragLocation: CGPoint?
    private var dragVelocity: CGVector = .zero
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
        if let previous = dragLocation {
            dragVelocity = CGVector(dx: location.x - previous.x, dy: location.y - previous.y)
        } else if let previous = previousDragLocation {
            dragVelocity = CGVector(dx: location.x - previous.x, dy: location.y - previous.y)
        } else {
            dragVelocity = .zero
        }
        previousDragLocation = location
        dragLocation = location
    }
    
    func handleDragEnded() {
        dragLocation = nil
        previousDragLocation = nil
        dragVelocity = .zero
    }
    
    private func rebuildGrid() {
        container.removeAllChildren()
        dots.removeAll()
        originalPositions.removeAll()
        displacements.removeAll()
        velocities.removeAll()
        
        guard size.width > 0, size.height > 0 else { return }
        
        let columns = max(Int(ceil(size.width / dotSpacing)), 1) + 2
        let rows = max(Int(ceil(size.height / dotSpacing)), 1) + 2
        let startX = -size.width / 2 - dotSpacing
        let startY = -size.height / 2 - dotSpacing
        
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
                displacements.append(.zero)
                velocities.append(.zero)
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
        
        if let dragLocation {
            applyWaveImpulse(center: dragLocation, deltaTime: deltaTime)
        }
        
        integrateMotion(deltaTime: deltaTime)
    }
    
    private func applyWaveImpulse(center: CGPoint, deltaTime: CGFloat) {
        let radius = influenceRadius
        let radiusSquared = radius * radius
        let forceScale = waveForce * deltaTime
        let directionalMagnitude = dragVelocity.length
        let flowDirection = directionalMagnitude > 0 ? CGVector(dx: dragVelocity.dx / directionalMagnitude, dy: dragVelocity.dy / directionalMagnitude) : .zero
        
        for index in dots.indices {
            let origin = originalPositions[index]
            let dx = origin.x - center.x
            let dy = origin.y - center.y
            let distanceSquared = dx * dx + dy * dy
            guard distanceSquared < radiusSquared else { continue }
            let distance = max(CGFloat(sqrt(distanceSquared)), 0.0005)
            let normalized = CGVector(dx: dx / distance, dy: dy / distance)
            let falloff = cos((distance / radius) * (.pi / 2))
            let radialImpulse = (falloff * falloff) * forceScale
            velocities[index].dx += normalized.dx * radialImpulse
            velocities[index].dy += normalized.dy * radialImpulse

            if directionalMagnitude > 0 {
                let tangential = CGVector(dx: -normalized.dy, dy: normalized.dx)
                let alignment = tangential.dot(flowDirection)
                let directionalImpulse = alignment * falloff * forceScale * 1.35 * Swift.min(directionalMagnitude / (dotSpacing + 1), 4)
                velocities[index].dx += tangential.dx * directionalImpulse
                velocities[index].dy += tangential.dy * directionalImpulse
            }
        }
    }
    
    private func integrateMotion(deltaTime: CGFloat) {
        let stiffness = self.stiffness
        let damping = self.damping
        let velocityDamping = CGFloat(pow(0.9, Double(deltaTime * 60)))
        for index in dots.indices {
            var displacement = displacements[index]
            var velocity = velocities[index]
            let accelerationX = -stiffness * displacement.dx - damping * velocity.dx
            let accelerationY = -stiffness * displacement.dy - damping * velocity.dy
            velocity.dx += accelerationX * deltaTime
            velocity.dy += accelerationY * deltaTime
            velocity.dx *= velocityDamping
            velocity.dy *= velocityDamping
            displacement.dx += velocity.dx * deltaTime
            displacement.dy += velocity.dy * deltaTime
            displacement.dx = displacement.dx.clamped(to: -influenceRadius * 0.85, influenceRadius * 0.85)
            displacement.dy = displacement.dy.clamped(to: -influenceRadius * 0.85, influenceRadius * 0.85)
            displacements[index] = displacement
            velocities[index] = velocity
            let origin = originalPositions[index]
            dots[index].position = CGPoint(x: origin.x + displacement.dx, y: origin.y + displacement.dy)
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
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

private extension CGFloat {
    var normalizedToPositiveAngle: CGFloat {
        var value = self
        while value < 0 { value += 2 * .pi }
        while value > 2 * .pi { value -= 2 * .pi }
        return value
    }
    
    func clamped(to minValue: CGFloat, _ maxValue: CGFloat) -> CGFloat {
        Swift.min(Swift.max(self, minValue), maxValue)
    }
}

private extension CGVector {
    var length: CGFloat { sqrt(dx * dx + dy * dy) }
    func dot(_ other: CGVector) -> CGFloat { dx * other.dx + dy * other.dy }
}

extension SKColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
}

#Preview {
    FullScreenDotFieldWave()
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
}
