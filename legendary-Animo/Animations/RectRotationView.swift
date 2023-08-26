//
//  RectRotationView.swift
//  ShapeAnimation
//
//  Created by Vishal Paliwal on 29/04/23.
//

import SwiftUI

struct RectRotationView: View {
    var body: some View {
        RectRotation()
    }
}

struct RectRotationView_Previews: PreviewProvider {
    static var previews: some View {
        RectRotationView()
            .preferredColorScheme(.dark)
    }
}

struct RectRotation: View {
    
    let radius: CGFloat = 28.0
    let dotLength: CGFloat = 22
    let dots: Int = 12
    var spaceLength: CGFloat = 8
    
    @State private var animate = false
    
    init() {
        self.spaceLength = getDotsSpace()
    }
    
    func getDotsSpace() -> CGFloat {
        let arcLength = CGFloat(2.0 * Double.pi) * radius
        let spaceLength = arcLength / CGFloat(dots) - dotLength
        return spaceLength
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<dots, id: \.self) { item in
                Rectangle()
                    .stroke(
                        LinearGradient(colors: [.indigo, .mint, .blue], startPoint: .top, endPoint: .bottom)
                        , style: StrokeStyle(lineWidth: 2, lineCap: .round,
                                             lineJoin: .round, miterLimit: 10,
                                            dash: [dotLength, spaceLength], dashPhase: 0)
                    )
                    .frame(width: radius * CGFloat(item), height: radius * CGFloat(item))
                    .scaleEffect(y: animate ? 1 : 0)
                    .rotationEffect(.degrees(animate ? 360 : 0))
                    .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true).delay((0.1 * Double(dots - item))), value: animate)
            }
        }
        .onAppear {
            animate.toggle()
        }
    }
    
}
