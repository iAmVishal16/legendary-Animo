//
//  Buttons.swift
//  InstantComponents
//
//  Created by Vishal Paliwal on 06/07/25.
//

import SwiftUI

enum MicroInteractionButtonState {
    case idle
    case loading
    case success
    case error
}

struct AnyShape: InsettableShape {
    private let _path: (CGRect) -> Path
    private let _inset: (CGFloat) -> AnyShape
    
    init<S: InsettableShape>(_ shape: S) {
        _path = { rect in shape.path(in: rect) }
        _inset = { amount in AnyShape(shape.inset(by: amount)) }
    }
    
    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
    func inset(by amount: CGFloat) -> AnyShape {
        _inset(amount)
    }
}

struct MicroInteractionButton: View {
    let icon: String
    let title: String
    let action: () async throws -> Void
    
    @State private var state: MicroInteractionButtonState = .idle
    @State private var rotation: Double = 0
    @State private var isAnimating: Bool = false
    @State private var showLoadingVisuals: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: handleTap) {
            ZStack {
                Capsule()
                    .fill(backgroundColor)
                    .frame(width: shapeWidth, height: shapeHeight)
                if state == .loading && showLoadingVisuals {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(1.2)
                } else if state == .loading {
                } else if state == .success {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .bold))
                } else if state == .error {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .bold))
                } else {
                    HStack {
                        Image(systemName: icon)
                            .foregroundColor(foregroundColor)
                        Text(title)
                            .foregroundColor(foregroundColor)
                            .fontWeight(.semibold)
                    }
                }
            }
            .frame(width: shapeWidth, height: shapeHeight)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: shapeWidth)
        }
        .disabled(state == .loading || state == .success || state == .error)
        .onChange(of: state) { newState in
            if newState == .loading {
                showLoadingVisuals = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.38) {
                    withAnimation(.easeIn(duration: 0.2)) {
                        showLoadingVisuals = true
                    }
                }
            } else if newState == .success {
                showLoadingVisuals = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.spring()) {
                        state = .idle
                    }
                }
            } else if newState == .error {
                showLoadingVisuals = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.spring()) {
                        state = .idle
                    }
                }
            } else {
                showLoadingVisuals = false
            }
        }
    }
    
    private var shapeWidth: CGFloat {
        state == .idle ? 220 : 56
    }
    private var shapeHeight: CGFloat {
        56
    }
    private var backgroundColor: Color {
        switch state {
        case .idle, .loading:
            // Adaptive background: dark in light mode, light in dark mode
            return colorScheme == .dark ? Color(.systemGray6) : Color(.label)
        case .success:
            return .green
        case .error:
            return .red
        }
    }
    private var foregroundColor: Color {
        switch state {
        case .idle, .loading:
            // Adaptive foreground: light in dark mode, dark in light mode (inverse of background)
            return colorScheme == .dark ? Color(.label) : Color(.systemBackground)
        case .success, .error:
            return .white // White on green/red is always readable
        }
    }
    
    private func handleTap() {
        Task {
            withAnimation(.spring()) { state = .loading }
            do {
                try await action()
                withAnimation(.spring()) { state = .success }
            } catch {
                withAnimation(.spring()) { state = .error }
                // Will reset to idle after delay in future step
            }
        }
    }
    
    private func startRotation() {
        isAnimating = true
        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
            rotation = 360
        }
    }
    private func stopRotation() {
        isAnimating = false
        rotation = 0
    }
    
    private var morphingShape: AnyShape {
        // No longer needed, but kept for compatibility if referenced elsewhere
        AnyShape(Capsule())
    }
}

#if DEBUG
struct MicroInteractionButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            MicroInteractionButton(icon: "applelogo", title: "Sign in with Apple") {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }
            .padding()
            MicroInteractionButton(icon: "heart.fill", title: "Like") {
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                throw NSError(domain: "Test", code: 1)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.light)
        
        VStack(spacing: 24) {
            MicroInteractionButton(icon: "applelogo", title: "Sign in with Apple") {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }
            .padding()
            MicroInteractionButton(icon: "heart.fill", title: "Like") {
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                throw NSError(domain: "Test", code: 1)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
#endif

