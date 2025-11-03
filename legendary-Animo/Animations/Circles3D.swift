//
//  Circles3D.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 9/28/25.
//

import SwiftUI

struct Circles3D: View {
    @State private var smallCircleOffset: CGFloat = -100
    @State private var smallCircleHeight: CGFloat = 50
    @State private var largeCircleOffset: CGFloat = 0
    @State private var largeCircleHeight: CGFloat = 100
    
    var body: some View {
        ZStack {
            // Small circle
            Circle()
                .stroke(lineWidth: 4)
                .frame(height: smallCircleHeight)
                .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 0, z: 0))
                .offset(y: smallCircleOffset)
            
            // Large circle
            Circle()
                .stroke(lineWidth: 4)
                .frame(height: largeCircleHeight)
                .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 0, z: 0))
                .offset(y: largeCircleOffset)
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        animatePositions()
    }
    
    private func animatePositions() {
        // First, animate positions
        withAnimation(.spring(response: 1.0, dampingFraction: 0.6, blendDuration: 0)) {
            smallCircleOffset = smallCircleOffset == -100 ? 100 : -100
            largeCircleOffset = largeCircleOffset == 0 ? -100 : 0
        }
        
        // After position animation completes, wait 2 seconds then animate sizes
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.animateSizes()
        }
    }
    
    private func animateSizes() {
        // Animate size changes
        withAnimation(.spring(response: 1.0, dampingFraction: 0.6, blendDuration: 0)) {
            smallCircleHeight = smallCircleHeight == 50 ? 100 : 50
            largeCircleHeight = largeCircleHeight == 100 ? 50 : 100
        }
        
        // Wait 1 second after size change, then repeat the cycle
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.animatePositions()
        }
    }
}

struct Circles3D_Previews: PreviewProvider {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    static var previews: some View {
        Circles3D()
    }
}
