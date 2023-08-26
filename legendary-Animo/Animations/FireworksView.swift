//
//  SwiftUIView.swift
//  ShapesFun
//
//  Created by Vishal Paliwal on 09/04/23.
//

import SwiftUI

struct FireworksView: View {
    var body: some View {
        ZStack {
            ForEach(0 ..< 15) { item in
                Fireworks(numberOfDots: 32, dotRadius: CGFloat(20 * item))
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FireworksView()
            .preferredColorScheme(.dark)
    }
}

struct Fireworks: View {
    
    let numberOfDots: Int
    let dotRadius: CGFloat
    
    @State var animate = false
        
        var body: some View {
            ZStack {
                ForEach(0..<numberOfDots, id: \.self) { index in
                    let angle = Double(index) * (360.0 / Double(numberOfDots))
                    let radians = angle * Double.pi / 180.0
                    let x = cos(radians) * Double(dotRadius * 2)
                    let y = sin(radians) * Double(dotRadius * 2)
                    Circle()
                        .fill(Color.mint)
                        .frame(width: animate ? 0.9 * CGFloat(index) : 0.9, height: animate ? 0.4 * CGFloat(index) : 0.4)
                        .offset(x: animate ? CGFloat(x) : -CGFloat(x), y: animate ? CGFloat(y) : -CGFloat(y))
                        .hueRotation(.degrees(animate ? 360 : 0))
                        .animation(Animation.easeOut(duration:   2.5).repeatForever(autoreverses: false).delay(0.2 * Double(index)), value: animate)
                }
            }
            .onAppear {
                animate.toggle()
            }
        }
    
}
