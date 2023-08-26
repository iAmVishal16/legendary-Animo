//
//  ShapesFunApp.swift
//  ShapesFun
//
//  Created by Vishal Paliwal on 22/01/23.
//

import SwiftUI

struct SpiralView: View {
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            ForEach(0..<6) { index in
                Spiral()
                    .fill(LinearGradient(gradient: Gradient(colors: [.yellow, .blue]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 200, height: 200)
                    .rotation3DEffect(.degrees(self.rotation + Double(60 * index)), axis: (x: 1, y: 0, z: 0))
            }
        }
        .animation(Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true))
        .onAppear {
            self.rotation = 360
        }
    }
}

struct Spiral: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let side = rect.width / 2.0
        let height = rect.height / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(side, height)
        let step: CGFloat = 0.05
        let turns: CGFloat = 2

        for i in stride(from: 0, to: turns * .pi, by: step) {
            let x = center.x + radius * cos(i)
            let y = center.y + radius * sin(i)
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path
    }
}

struct SpiralView_Previews: PreviewProvider {
    static var previews: some View {
        SpiralView()
    }
}
