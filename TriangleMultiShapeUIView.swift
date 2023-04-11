//
//  TriangleMultiShapeUIView.swift
//  ShapeAnimation
//
//  Created by Vishal Paliwal on 08/04/23.
//

import SwiftUI

struct TriangleMultiShapeUIView: View {
    
    @State private var isAnimating = false
    @State private var rotation = 360.0
    
    var body: some View {
        ZStack {
            Triangle()
                .stroke(lineWidth: 2)
                .fill(
                    LinearGradient(colors: [.red, .orange, .blue],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .frame(width: 325, height: 325, alignment: .center)
                .rotation3DEffect(.degrees(isAnimating ? rotation : 0), axis: (x: 0, y: 1, z: 0))
                .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true),
                           value: isAnimating)
            
            Rectangle()
                .stroke(lineWidth: 2)
                .fill(
                    LinearGradient(colors: [.blue, .yellow, .red],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .frame(width: 325, height: 325, alignment: .center)
                .rotation3DEffect(.degrees(isAnimating ? rotation : 45), axis: (x: 0, y: 1, z: 0))
                .animation(Animation.easeInOut(duration: 2)
                    .repeatForever(autoreverses: true).delay(0.2),
                           value: isAnimating)
            
            Circle()
                .stroke(lineWidth: 2)
                .fill(
                    LinearGradient(colors: [.red, .indigo, .cyan],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .frame(width: 325, height: 325, alignment: .center)
                .rotation3DEffect(.degrees(isAnimating ? rotation : 90), axis: (x: 0, y: 1, z: 0))
                .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(0.4),
                           value: isAnimating)
            
            Ellipse()
                .stroke(lineWidth: 2)
                .fill(
                    LinearGradient(colors: [.red, .blue, .indigo],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .frame(width: 325, height: 325, alignment: .center)
                .rotation3DEffect(.degrees(isAnimating ? rotation : 120), axis: (x: 0, y: 1, z: 0))
                .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(0.6),
                           value: isAnimating)
            
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 2)
                .fill(
                    LinearGradient(colors: [.blue, .yellow, .purple],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .frame(width: 325, height: 325, alignment: .center)
                .rotation3DEffect(.degrees(isAnimating ? rotation : 140), axis: (x: 0, y: 1, z: 0))
                .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(0.8),
                           value: isAnimating)
            
            Capsule()
                .stroke(lineWidth: 2)
                .fill(
                    LinearGradient(colors: [.teal, .cyan, .pink],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .frame(width: 325, height: 325, alignment: .center)
                .rotation3DEffect(.degrees(isAnimating ? rotation : 0), axis: (x: 0, y: 1, z: 0))
                .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(1.2),
                           value: isAnimating)
            
            Triangle()
                .stroke(lineWidth: 2)
                .fill(
                    LinearGradient(colors: [.blue, .orange, .red],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .frame(width: 325, height: 325, alignment: .center)
                .rotation3DEffect(.degrees(isAnimating ? rotation : 90), axis: (x: 0, y: 1, z: 0))
                .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(1.4),
                           value: isAnimating)
        }
        .onAppear {
            isAnimating.toggle()
        }
    }
}

struct TriangleMultiShapeUIView_Previews: PreviewProvider {
    static var previews: some View {
        TriangleMultiShapeUIView()
            .preferredColorScheme(.dark)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}
