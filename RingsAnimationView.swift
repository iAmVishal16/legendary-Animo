//
//  RingsAnimationView.swift
//  ShapeAnimation
//
//  Created by Vishal Paliwal on 03/04/23.
//

import SwiftUI

struct RingsAnimationView: View {
    
    @State private var yPos: CGFloat = 0
    @State private var isAnimating = false
    
    let colors: [Color] = [.pink, .orange, .yellow, .green
                           , .blue, .purple, .pink, .white
                           , .cyan, .mint, .teal, .indigo]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<colors.count - 1) { i in
                    let color1 = colors[i]
                    let color2 = colors[i + 1]
                    
                    Circle()
                        .stroke(lineWidth: 8)
                        .stroke(
                            LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: geometry.size.width,
                               height: geometry.size.height / CGFloat(colors.count - 1), alignment: .center)
                        .offset(y: CGFloat(i) * yPos)
                        .rotation3DEffect(.degrees(isAnimating ? 250 : 50), axis: (x: 1, y: 0, z: 0))
                }
            }
            .onAppear {
                isAnimating.toggle()
                withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: true)) {
                    yPos = -UIScreen.main.bounds.size.height
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RingsAnimationView()
    }
}
