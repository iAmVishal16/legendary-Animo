//
//  CirclesRotationsView.swift
//  ShapeAnimation
//
//  Created by Vishal Paliwal on 10/09/23.
//

import SwiftUI

struct CirclesRotations_Previews: PreviewProvider {
    static var previews: some View {
        CirclesRotations(count: 5)
            .frame(width: 100, height: 100, alignment: .center)
            .padding()
            .preferredColorScheme(.dark)
    }
}

struct CirclesRotations: View {
    
    let count: Int
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<count, id: \.self) { index in
                CircleView(index: index, size: geometry.size)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct CircleView: View {
    
    let index: Int
    let size: CGSize
    
    @State private var scale: CGFloat = 0
    @State private var rotation: Double = 0
    
    var body: some View {
        let animation = Animation
            .timingCurve(0.95, 0.55 + Double(index) / 5, 0.65, 1, duration: 2.5)
            .repeatForever(autoreverses: true)
        
        return RoundedRectangle(cornerRadius: 8)
            .frame(width: size.width / 1, height: size.height / 1)
            .scaleEffect(scale)
            .foregroundColor(getColor(index: index))
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 4.0)
                    .frame(width: size.width / 1, height: size.height / 1)
                    .scaleEffect(scale * 1.1)
                    .opacity(0.8)
            }
            .rotation3DEffect(
                .degrees(rotation),
                axis: (x: 1.0, y: 1.0, z: 1.0),
                anchor: .center,
                anchorZ: 5.6,
                perspective: 0.0
            )
            .offset(x: size.width / 20, y: size.width / 20 - size.height)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                rotation = 0
                scale = (5 - CGFloat(index)) / 5
                withAnimation(animation) {
                    rotation = 360
                    scale = (1 + CGFloat(index)) / 5
                }
            }
        
    }
    
    func getColor(index: Int) -> Color {
        
        switch index {
        case 0:
            return .red
        case 1:
            return .green
        case 2:
            return .blue
        case 3:
            return .mint
        case 4:
            return .purple
        case 5:
            return .cyan
        default:
            break
        }
        
        return .red
    }
}
