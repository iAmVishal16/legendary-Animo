//
//  ChipsDrags.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 10/1/25.
//

import SwiftUI

// MARK: - Model
struct Chip: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let icon: String
    var color: Color
    var seed: Double = Double.random(in: -8...8) // for subtle rotation/animation staggering
}

// MARK: - Frame Preference to hit-test chips during drag
private struct ChipFramePreferenceKey: PreferenceKey {
    static var defaultValue: [UUID: CGRect] = [:]
    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

// MARK: - Main View
struct ChipsView: View {
    @State private var chips: [Chip] = [
        Chip(label: "Love", icon: "heart.fill", color: Color.purple.opacity(0.9)),
        Chip(label: "Friend", icon: "person.2.fill", color: Color.yellow.opacity(0.9)),
        Chip(label: "Music", icon: "music.note", color: Color.white.opacity(0.95)),
        Chip(label: "Beauty", icon: "snowflake", color: Color.blue.opacity(0.9)),
        Chip(label: "Education", icon: "book.fill", color: Color.pink.opacity(0.9)),
        Chip(label: "Shopping", icon: "cart.fill", color: Color.blue.opacity(0.85)),
        Chip(label: "Art", icon: "paintpalette.fill", color: Color.yellow.opacity(0.85)),
        Chip(label: "Technology", icon: "desktopcomputer", color: Color.indigo.opacity(0.9)),
        Chip(label: "Peace", icon: "hand.raised.fill", color: Color.white.opacity(0.95)),
        Chip(label: "Fashion", icon: "scissors", color: Color.pink.opacity(0.85)),
        Chip(label: "Company", icon: "building.2.fill", color: Color.yellow.opacity(0.85))
    ]

    @State private var framesById: [UUID: CGRect] = [:]
    @State private var draggingId: UUID?
    @State private var dragTranslation: CGSize = .zero
    @State private var hasAppeared = false

    private let grid = [GridItem(.adaptive(minimum: 130), spacing: 14)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Drag & Reorder Your Interests")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                Text("Personalize your bot by arranging the topics that matter most to you.")
                    .font(.title3)
                    .foregroundStyle(.gray)
            }

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: grid, spacing: 14) {
                    ForEach(chips) { chip in
                        ChipCell(chip: chip)
                            .scaleEffect(draggingId == chip.id ? 1.05 : 1.0)
                            .rotationEffect(.degrees(hasAppeared ? chip.seed : -25))
                            .offset(y: hasAppeared ? (draggingId == chip.id ? dragTranslation.height : 0) : -400)
                            .offset(x: draggingId == chip.id ? dragTranslation.width : 0)
                            .animation(.spring(response: 0.45, dampingFraction: 0.8), value: chips)
                            .animation(.spring(response: 0.65, dampingFraction: 0.75), value: draggingId)
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .preference(key: ChipFramePreferenceKey.self, value: [chip.id: proxy.frame(in: .global)])
                                }
                            )
                            .gesture(
                                DragGesture(minimumDistance: 1)
                                    .onChanged { value in
                                        if draggingId == nil { draggingId = chip.id }
                                        dragTranslation = value.translation
                                        // Compute the global location under the finger
                                        let finger = CGPoint(x: value.startLocation.x + value.translation.width,
                                                             y: value.startLocation.y + value.translation.height)
                                        if let activeId = draggingId,
                                           let fromIndex = chips.firstIndex(where: { $0.id == activeId }) {
                                            if let targetIndex = nearestIndex(at: finger, excluding: activeId), targetIndex != fromIndex {
                                                withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
                                                    let element = chips.remove(at: fromIndex)
                                                    chips.insert(element, at: targetIndex)
                                                }
                                            }
                                        }
                                    }
                                    .onEnded { _ in
                                        draggingId = nil
                                        dragTranslation = .zero
                                    }
                            )
        .onAppear {
                                if !hasAppeared {
                                    // Stagger drop animation per chip
                                    let idx = Double(chips.firstIndex(where: { $0.id == chip.id }) ?? 0)
                                    withAnimation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.05 * idx)) {
                                        hasAppeared = true
                                    }
                                }
                            }
                    }
                }
                .padding(.top, 8)
            }

            Button(action: {}, label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            })
        }
        .padding(.horizontal, 24)
        .onPreferenceChange(ChipFramePreferenceKey.self) { frames in
            framesById = frames
        }
    }

    // Find the index of the chip whose frame contains the drag location or the nearest one
    private func nearestIndex(at point: CGPoint, excluding id: UUID) -> Int? {
        let otherFrames = framesById.filter { $0.key != id }
        // If any frame contains the point, prefer that
        if let target = otherFrames.first(where: { $0.value.contains(point) }),
           let index = chips.firstIndex(where: { $0.id == target.key }) {
            return index
        }
        // Otherwise, choose the closest center distance
        let best = otherFrames.min { lhs, rhs in
            lhs.value.centerPoint.distance(to: point) < rhs.value.centerPoint.distance(to: point)
        }
        if let best, let idx = chips.firstIndex(where: { $0.id == best.key }) { return idx }
        return nil
    }
}

// MARK: - Chip Cell
private struct ChipCell: View {
    let chip: Chip
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: chip.icon)
                .font(.subheadline)
            Text(chip.label)
                .font(.subheadline.weight(.semibold))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .foregroundColor(.black)
        .background(chip.color)
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 4)
    }
}

// MARK: - Helpers
private extension CGRect {
    var centerPoint: CGPoint { CGPoint(x: midX, y: midY) }
}

private extension CGPoint {
    func distance(to other: CGPoint) -> CGFloat {
        let dx = x - other.x
        let dy = y - other.y
        return sqrt(dx*dx + dy*dy)
    }
}

#Preview(body: {
    ChipsView()
        .preferredColorScheme(.dark)
})

// MARK: - ChipsViewV2 (Optimized drop-in arrangement)
struct ChipsViewV2: View {
    @State private var chips: [Chip] = [
        Chip(label: "Love", icon: "heart.fill", color: Color.purple.opacity(0.9)),
        Chip(label: "Friend", icon: "person.2.fill", color: Color.yellow.opacity(0.9)),
        Chip(label: "Music", icon: "music.note", color: Color.white.opacity(0.95)),
        Chip(label: "Beauty", icon: "snowflake", color: Color.blue.opacity(0.9)),
        Chip(label: "Education", icon: "book.fill", color: Color.pink.opacity(0.9)),
        Chip(label: "Shopping", icon: "cart.fill", color: Color.blue.opacity(0.85)),
        Chip(label: "Art", icon: "paintpalette.fill", color: Color.yellow.opacity(0.85)),
        Chip(label: "Technology", icon: "desktopcomputer", color: Color.indigo.opacity(0.9)),
        Chip(label: "Peace", icon: "hand.raised.fill", color: Color.white.opacity(0.95)),
        Chip(label: "Fashion", icon: "scissors", color: Color.pink.opacity(0.85)),
        Chip(label: "Company", icon: "building.2.fill", color: Color.yellow.opacity(0.85))
    ]

    @State private var startDrop = false
    @State private var framesById: [UUID: CGRect] = [:]
    @State private var draggingId: UUID?
    @State private var dragTranslation: CGSize = .zero

    private let grid = [GridItem(.adaptive(minimum: 130), spacing: 14)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Choose your bot’s categories")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                Text("We’ll drop them in one by one. Enjoy the micro-interaction.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: grid, spacing: 14) {
                    ForEach(chips) { chip in
                        let index = Double(chips.firstIndex(where: { $0.id == chip.id }) ?? 0)
                        ChipCell(chip: chip)
                            .scaleEffect(draggingId == chip.id ? 1.05 : 1.0)
                            .opacity(startDrop ? 1 : 0)
                            .offset(y: startDrop ? (draggingId == chip.id ? dragTranslation.height : 0) : -300)
                            .offset(x: draggingId == chip.id ? dragTranslation.width : 0)
                            .rotationEffect(.degrees(startDrop ? (draggingId == chip.id ? 0 : 0) : -25 + chip.seed))
                            .animation(
                                .spring(response: 0.65, dampingFraction: 0.8)
                                .delay(0.06 * index),
                                value: startDrop
                            )
                            .animation(.spring(response: 0.45, dampingFraction: 0.85), value: chips)
                            .animation(.spring(response: 0.55, dampingFraction: 0.8), value: draggingId)
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .preference(key: ChipFramePreferenceKey.self, value: [chip.id: proxy.frame(in: .global)])
                                }
                            )
                            .gesture(
                                DragGesture(minimumDistance: 1)
                                    .onChanged { value in
                                        if draggingId == nil { draggingId = chip.id }
                                        dragTranslation = value.translation
                                        let finger = CGPoint(x: value.startLocation.x + value.translation.width,
                                                             y: value.startLocation.y + value.translation.height)
                                        if let activeId = draggingId,
                                           let fromIndex = chips.firstIndex(where: { $0.id == activeId }) {
                                            if let targetIndex = nearestIndexV2(at: finger, excluding: activeId), targetIndex != fromIndex {
                                                withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
                                                    let element = chips.remove(at: fromIndex)
                                                    chips.insert(element, at: targetIndex)
                                                }
                                            }
                                        }
                                    }
                                    .onEnded { _ in
                                        draggingId = nil
                                        dragTranslation = .zero
                                    }
                            )
                    }
                }
                .padding(.top, 8)
            }

            Button(action: replayDrop, label: {
                Text("Replay")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            })
        }
        .padding(.horizontal, 24)
        .onAppear { triggerDrop() }
        .onPreferenceChange(ChipFramePreferenceKey.self) { frames in
            framesById = frames
        }
    }

    private func triggerDrop() {
        startDrop = false
        // Use a tiny delay so that the appearance state toggles and animations apply
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            withAnimation { startDrop = true }
        }
    }

    private func replayDrop() {
        triggerDrop()
    }

    // MARK: - Hit-testing and reordering
    private func nearestIndexV2(at point: CGPoint, excluding id: UUID) -> Int? {
        let otherFrames = framesById.filter { $0.key != id }
        if let target = otherFrames.first(where: { $0.value.contains(point) }),
           let index = chips.firstIndex(where: { $0.id == target.key }) {
            return index
        }
        let best = otherFrames.min { lhs, rhs in
            lhs.value.centerPoint.distance(to: point) < rhs.value.centerPoint.distance(to: point)
        }
        if let best, let idx = chips.firstIndex(where: { $0.id == best.key }) { return idx }
        return nil
    }
}

#Preview(body: {
    ChipsViewV2()
        .preferredColorScheme(.dark)
})

// MARK: - FallingChipsView with Physics Simulation
struct FallingChipsView: View {
    @State private var physicsController: PhysicsController?
    @State private var hasStarted = false
    
    private let categories: [(String, String, Color)] = {
        // Prominent, intuitive colors for dietary preferences
        let vegetarianColor = Color(red: 0.22, green: 0.67, blue: 0.32) // Green
        let veganColor = Color(red: 0.13, green: 0.60, blue: 0.18) // Darker Green
        let glutenFreeColor = Color(red: 0.98, green: 0.85, blue: 0.37) // Gold/Yellow
        let dairyFreeColor = Color(red: 0.36, green: 0.70, blue: 0.98) // Light Blue
        let nutFreeColor = Color(red: 0.91, green: 0.30, blue: 0.24) // Red
        let pescatarianColor = Color(red: 0.20, green: 0.60, blue: 0.86) // Blue
        let ketoColor = Color(red: 0.56, green: 0.27, blue: 0.68) // Purple
        let paleoColor = Color(red: 0.80, green: 0.52, blue: 0.25) // Brown/Orange
        let halalColor = Color(red: 0.13, green: 0.75, blue: 0.61) // Teal
        let kosherColor = Color(red: 0.29, green: 0.36, blue: 0.67) // Indigo
        let lowCarbColor = Color(red: 0.13, green: 0.80, blue: 0.60) // Mint/Teal
        let lowSugarColor = Color(red: 0.98, green: 0.56, blue: 0.67) // Pink
        let organicColor = Color(red: 0.36, green: 0.78, blue: 0.36) // Bright Green
        let noSoyColor = Color(red: 0.60, green: 0.60, blue: 0.60) // Gray

        return [
            ("Vegetarian", "leaf.fill", vegetarianColor),
            ("Vegan", "carrot.fill", veganColor),
            ("Gluten-Free", "circle.lefthalf.filled", glutenFreeColor),
            ("Dairy-Free", "drop.triangle.fill", dairyFreeColor),
            ("Nut-Free", "nosign", nutFreeColor),
            ("Pescatarian", "fish.fill", pescatarianColor),
            ("Keto", "bolt.fill", ketoColor),
            ("Paleo", "flame.fill", paleoColor),
            ("Halal", "checkmark.seal.fill", halalColor),
            ("Kosher", "staroflife.fill", kosherColor),
            ("Low-Carb", "arrow.down.right.circle.fill", lowCarbColor),
            ("Low-Sugar", "cube.fill", lowSugarColor),
            ("Organic", "leaf.arrow.circlepath", organicColor),
            ("No Soy", "xmark.seal.fill", noSoyColor)
        ]
    }()
    
    
    var body: some View {
        ZStack {
            // Dark background
            Color(red: 0.07, green: 0.07, blue: 0.07) // #121212
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    Text("Choose your Dietary preferences")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.gradient)
                    
                    Text("Watch as your interests fall into place naturally")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 200)
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer()
                
                // Physics container - give it a specific height to work with
                PhysicsContainerView(
                    categories: categories,
                    hasStarted: $hasStarted,
                    physicsController: $physicsController
                )
                .frame(maxWidth: .infinity, minHeight: 500)
                .layoutPriority(1) // Give it priority to expand
//                .background(.red)
                
                Spacer()
                
                // falling top edge
                LinearGradient(colors: [.black.opacity(0.2), .white, .white.opacity(0.5), .black.opacity(0.2)], startPoint: .leading, endPoint: .trailing)
                    .blur(radius: 4)
                    .frame(height: 2, alignment: .center)
                    .padding(.bottom, 24)
                    .padding(.horizontal)
                
                // Continue button
                Button(action: {}) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.white.gradient)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            // Start physics simulation after a brief delay to ensure layout is complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                print("Starting physics simulation...")
                hasStarted = true
            }
        }
    }
}

// MARK: - Physics Container View
struct PhysicsContainerView: UIViewRepresentable {
    let categories: [(String, String, Color)]
    @Binding var hasStarted: Bool
    @Binding var physicsController: PhysicsController?
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.clear
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if hasStarted && physicsController == nil {
            // Create physics controller when simulation should start
            let controller = PhysicsController(containerView: uiView, categories: categories)
            physicsController = controller
            
            // Wait a bit more for layout to complete, then start simulation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                controller.startSimulation()
            }
        }
        
        // Update bottom boundary when view size changes
        if let controller = physicsController {
            controller.updateBottomBoundary()
        }
    }
}

// MARK: - Physics Controller
class PhysicsController: NSObject, UIDynamicAnimatorDelegate {
    private let containerView: UIView
    private let categories: [(String, String, Color)]
    private var animator: UIDynamicAnimator?
    private var gravity: UIGravityBehavior?
    private var collision: UICollisionBehavior?
    private var itemBehavior: UIDynamicItemBehavior?
    private var chips: [UIView] = []
    private var expectedChipCount: Int = 0
    private var createdChipCount: Int = 0
    
    init(containerView: UIView, categories: [(String, String, Color)]) {
        self.containerView = containerView
        self.categories = categories
        super.init()
        setupPhysics()
    }
    
    private func setupPhysics() {
        // Create dynamic animator
        animator = UIDynamicAnimator(referenceView: containerView)
        animator?.delegate = self
        
        // Create gravity
        gravity = UIGravityBehavior()
        gravity?.magnitude = 1.35 // Stronger gravity to avoid mid-air stalls
        
        // Create collision behavior (manual boundaries; no top so items can fall in)
        collision = UICollisionBehavior()
        collision?.translatesReferenceBoundsIntoBoundary = false
        
        // Create item behavior for bounciness and rotation
        itemBehavior = UIDynamicItemBehavior()
        itemBehavior?.elasticity = 0.35 // Slightly bouncier
        itemBehavior?.friction = 0.18 // Lower friction so stacks settle
        itemBehavior?.resistance = 0.02 // Very low air resistance so they keep moving
        itemBehavior?.angularResistance = 0.02
        itemBehavior?.allowsRotation = true // Allow rotation on impact
        
        // Add behaviors to animator
        if let gravity = gravity { animator?.addBehavior(gravity) }
        if let collision = collision { animator?.addBehavior(collision) }
        if let itemBehavior = itemBehavior { animator?.addBehavior(itemBehavior) }

        // Periodic nudge to prevent deadlocks in mid-air clusters
        let tick = UIDynamicBehavior()
        tick.action = { [weak self] in
            guard let self = self, let itemBehavior = self.itemBehavior else { return }
            let bottomY = self.containerView.bounds.height
            var anyAboveFloor = false
            var allResting = !self.chips.isEmpty
            for view in self.chips {
                let v = itemBehavior.linearVelocity(for: view)
                let speed = hypot(v.x, v.y)
                let aboveFloor = view.center.y < bottomY - 42
                if aboveFloor { anyAboveFloor = true }
                if speed > 6 || aboveFloor { allResting = false }
                // Nudge slow movers above the floor
                if speed < 12 && aboveFloor {
                    let pushY: CGFloat = 140
                    let pushX: CGFloat = CGFloat.random(in: -18...18)
                    itemBehavior.addLinearVelocity(CGPoint(x: pushX, y: pushY), for: view)
                }
            }
            // Keep simulation alive until all created and resting
            let allCreated = (self.createdChipCount >= self.expectedChipCount)
            let mustKeepRunning = !(allCreated && allResting)
            if mustKeepRunning, let animator = self.animator, animator.isRunning == false {
                self.gravity?.magnitude = 1.5
                if let first = self.chips.first {
                    itemBehavior.addLinearVelocity(CGPoint(x: 0, y: 8), for: first)
                }
            }
        }
        animator?.addBehavior(tick)
    }

    // MARK: - UIDynamicAnimatorDelegate
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        // If animator paused but some items are still above the bottom, wake it with a tiny push
        let bottomY = containerView.bounds.height
        let stuck = chips.filter { $0.center.y < bottomY - 42 }
        guard !stuck.isEmpty, let itemBehavior = itemBehavior else { return }
        // Continuous push for a bit longer; enough to wake and keep moving
        let push = UIPushBehavior(items: stuck, mode: .continuous)
        push.pushDirection = CGVector(dx: 0, dy: 0.5)
        animator.addBehavior(push)
        // Also add a small linear velocity to the first to ensure motion
        if let first = stuck.first {
            itemBehavior.addLinearVelocity(CGPoint(x: 0, y: 40), for: first)
        }
        // Remove push after a short period
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            animator.removeBehavior(push)
        }
    }
    
    func startSimulation() {
        guard let gravity = gravity, let collision = collision else { return }
        
        // Update boundary first to ensure proper positioning
        updateBottomBoundary()
        
        // Create chips with staggered delays
        expectedChipCount = categories.count
        createdChipCount = 0
        for (index, category) in categories.enumerated() {
            var delay = Double.random(in: 0.05...0.2) + (Double(index) * 0.5)
            
            if index == expectedChipCount - 1 {
                delay = 10.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.createChip(category: category, gravity: gravity, collision: collision)
            }
        }
    }
    
    private func createChip(category: (String, String, Color), gravity: UIGravityBehavior, collision: UICollisionBehavior) {
        let chipView = createChipView(category: category)
        containerView.addSubview(chipView)
        chips.append(chipView)
        createdChipCount += 1
        
        // Random starting position ABOVE the screen
        let screenWidth = containerView.bounds.width > 0 ? containerView.bounds.width : 375
        let randomX = CGFloat.random(in: 60...(screenWidth - 60))
        let startY: CGFloat = -100 // Start well above the screen
        chipView.center = CGPoint(x: randomX, y: startY)
        
        // Force layout and compute best-fitting size from Auto Layout
        chipView.setNeedsLayout()
        chipView.layoutIfNeeded()
        let fitting = chipView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let finalSize = CGSize(width: max(120, fitting.width), height: max(40, fitting.height))
        chipView.frame.size = finalSize
        
        // Add random initial rotation
        let randomRotation = CGFloat.random(in: -10...10) * .pi / 180
        chipView.transform = CGAffineTransform(rotationAngle: randomRotation)
        
        // Add to physics behaviors
        gravity.addItem(chipView)
        collision.addItem(chipView)
        itemBehavior?.addItem(chipView)
        
        // Add random angular velocity for spinning effect
        let randomAngularVelocity = CGFloat.random(in: -2...2)
        itemBehavior?.addAngularVelocity(randomAngularVelocity, for: chipView)

        // Kick-start motion so a late chip definitely begins to fall
        let initialVX = CGFloat.random(in: -40...40)
        let initialVY: CGFloat = 260
        itemBehavior?.addLinearVelocity(CGPoint(x: initialVX, y: initialVY), for: chipView)

        // If animator is currently paused, apply a short continuous push to wake it
        if let animator = animator, animator.isRunning == false {
            let push = UIPushBehavior(items: [chipView], mode: .continuous)
            push.pushDirection = CGVector(dx: 0, dy: 0.7)
            animator.addBehavior(push)
            // Keep push a bit longer so it doesn't stop immediately
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                animator.removeBehavior(push)
            }
        }

        print("Created chip: \(category.0) at start position: \(chipView.center), container bounds: \(containerView.bounds)")
    }
    
    private func createChipView(category: (String, String, Color)) -> UIView {
        let chipView = UIView()
        chipView.backgroundColor = UIColor(category.2)
        chipView.layer.cornerRadius = 20
        chipView.layer.shadowColor = UIColor.black.cgColor
        chipView.layer.shadowOffset = CGSize(width: 0, height: 4)
        chipView.layer.shadowOpacity = 0.2
        chipView.layer.shadowRadius = 8
        
        // Create label
        let label = UILabel()
        label.text = category.0
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byClipping // Prevent ellipsis
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        // Create icon
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: category.1)
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        iconImageView.setContentHuggingPriority(.required, for: .vertical)
        
        // Create stack view
        let stackView = UIStackView(arrangedSubviews: [iconImageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill // Allow label to expand
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        chipView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Calculate text size to determine if we need more width
        let textSize = category.0.size(withAttributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ])
        let iconWidth: CGFloat = 16
        let spacing: CGFloat = 8
        let padding: CGFloat = 32 // 16px on each side
        let minWidth: CGFloat = 80
        let requiredWidth = iconWidth + spacing + textSize.width + padding
        let finalWidth = max(minWidth, requiredWidth)
        
        // Dynamic sizing with calculated width
        NSLayoutConstraint.activate([
            // Stack view constraints with 16px padding
            stackView.leadingAnchor.constraint(equalTo: chipView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: chipView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: chipView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: chipView.bottomAnchor, constant: -12),
            
            // Icon size constraints
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16),
            
            // No explicit width constraint; allow intrinsic width to determine size
        ])
        
        // Set intrinsic content size - allow chip to expand
        chipView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        chipView.setContentHuggingPriority(.required, for: .vertical)
        chipView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return chipView
    }
    
    func updateBottomBoundary() {
        guard let collision = collision, containerView.bounds.height > 0 else {
            print("Cannot update boundary - collision or container bounds not ready")
            return
        }
        
        // Remove existing custom boundaries if any
        collision.removeBoundary(withIdentifier: "bottomBoundary" as NSCopying)
        collision.removeBoundary(withIdentifier: "leftBoundary" as NSCopying)
        collision.removeBoundary(withIdentifier: "rightBoundary" as NSCopying)
        
        // Add boundaries: left, right, and bottom only (no top boundary)
        let width = containerView.bounds.width
        let height = containerView.bounds.height
        let bottomY = height
        
        print("Updating boundaries — bottomY: \(bottomY), width: \(width), height: \(height)")
        
        collision.addBoundary(withIdentifier: "leftBoundary" as NSCopying,
                              from: CGPoint(x: 0, y: -1000),
                              to:   CGPoint(x: 0, y: bottomY))
        
        collision.addBoundary(withIdentifier: "rightBoundary" as NSCopying,
                              from: CGPoint(x: width, y: -1000),
                              to:   CGPoint(x: width, y: bottomY))
        
        collision.addBoundary(withIdentifier: "bottomBoundary" as NSCopying,
                              from: CGPoint(x: 0, y: bottomY),
                              to:   CGPoint(x: width, y: bottomY))
    }
}

#Preview {
    FallingChipsView()
        .preferredColorScheme(.dark)
}
