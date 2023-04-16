//
//  DotsAnimPreview.swift
//  ShapeAnimation
//
//  Created by Vishal Paliwal on 15/04/23.
//

import SwiftUI

struct DotsAnimPreview: View {
    var body: some View {
        DotsCircleView()
    }
}

struct DotsAnimPreview_Previews: PreviewProvider {
    static var previews: some View {
        DotsAnimPreview()
            .preferredColorScheme(.dark)
    }
}

struct DotsCircleView: View {
    
    @State private var animate = false
    
    let radius: CGFloat = 12
    let dots = 24
    let offset: CGFloat
    let pi = Double.pi
    let dotLength: CGFloat = 8
    let spaceLength: CGFloat
    
    init() {
        let arcLength = CGFloat(2.0 * pi) * radius
        spaceLength = arcLength / CGFloat(dots) - dotLength
        offset = 200
    }
    
    var body: some View {
        ZStack {
            ForEach(0 ..< dots, id: \.self) { item in
                Circle()
                    .stroke(
                        LinearGradient(colors: [.blue, .cyan, .indigo],
                                       startPoint: .top, endPoint: .bottom),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round,
                                           lineJoin: .round, miterLimit: 10, dash: [dotLength, spaceLength], dashPhase: 0)
                    )
                .frame(width: (radius * CGFloat(item)), height: (radius * CGFloat(item)))
                .offset(y : animate ? -offset : offset)
//                .scaleEffect(y : animate ? 1 : 0)
                .animation(Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true).delay((0.1 * Double(dots - item))),
                           value: animate)
            }
        }
        .onAppear {
            animate.toggle()
        }
    }
}

