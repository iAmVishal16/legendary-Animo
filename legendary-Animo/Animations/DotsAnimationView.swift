//
//  DotsAnimationView.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 29/01/24.
//

import SwiftUI

#Preview {
    DotsAnimationView()
        .preferredColorScheme(.dark)
}

struct DotsAnimationView: View {
    
    @State private var offset: CGFloat = -130
    @State private var rotation: Double = 0.0
    
    var body: some View {
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ZStack {
                ForEach(0 ..< 20) { i in
                    Rectangle()
                        .frame(width: 20, height: 20)
                        .rotation3DEffect(
                        .degrees(45),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .foregroundColor(.cyan)
                        .offset(x: offset, y: offset)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay((0.1 * Double(20 - i))),
                                   value: offset)
                        .rotationEffect(.degrees(360 / 20 * Double(i)))
                        .hueRotation(.degrees(rotation))
                }
                
                ForEach(0 ..< 20) { i in
                    Rectangle()
                        .frame(width: 20, height: 20)
                        .rotation3DEffect(
                        .degrees(45),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .foregroundColor(.cyan)
                        .offset(x: offset * 0.5, y: offset * 0.5)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay((0.1 * Double(20 - i))),
                                   value: offset)
                        .rotationEffect(.degrees(360 / 20 * Double(i)))
                        .hueRotation(.degrees(rotation))
                }
            }
            .rotationEffect(.degrees(rotation))
            .animation(.linear(duration: 5).repeatForever(), value: rotation)
        }
        .onAppear {
            offset += 30
            rotation = 360
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                offset += 100
            }
        }
    }
}
