//
//  StarsBlinkView.swift
//  StarsBlink
//
//  Created by Vishal Paliwal on 15/07/23.
//

import SwiftUI

struct StarsBlinkView: View {
    
    @State private var stars: [StarProperties] = []
    
    @State private var angle: Angle = .zero
    
    // We will animate following properties of Star Shape
    struct StarProperties: Identifiable {
        let id = UUID()
        let position: CGPoint
        var scale: CGFloat = 1.0
        var opacity: Double = 1.0
        var hue: Angle = .zero
    }
    
    // Lets jump to body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // We'll add a Gradient to give a good bg effect
                RoundedRectangle(cornerRadius: 0)
                    .fill(
                        AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .top, angle: angle)
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .blur(radius: 24)
                    .opacity(0.2)
                    .animation(Animation.easeInOut(duration: 5.0).repeatForever(), value: angle)
                
                // We'll add our Star shape here and
                // animate w.r.t birth rate, scale and opacity
                // Let's create our Star Shape first
                
                let randomFrame = CGFloat.random(in: 0...50)
                
                ForEach(stars) { star in
                    Star()
                        .fill(Color.mint)
                        .frame(width: randomFrame, height: randomFrame)
                        .scaleEffect(star.scale)
                        .opacity(star.opacity)
                        .position(star.position)
                        .hueRotation(star.hue)
                        .blur(radius: star.opacity)
                        .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true))
                }
                
            }
            .onAppear {
                // Lets animate our Gradient
                withAnimation(Animation.easeInOut(duration: 0.5)) {
                    self.angle = .degrees(360)
                }
                
                startAnimatingStars(in: geometry.size)
            }
        }
    }
    
    // LEt's create a function which will provide stars random position
    // also we can control birth rate and other properties
    private func startAnimatingStars(in size: CGSize) {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            let randomX = CGFloat.random(in: 0...size.width)
            let randomY = CGFloat.random(in: 0...size.height)
            let randomHue = Angle(degrees: Double(CGFloat.random(in: 0...360)))
            
            let newStar = StarProperties(position: CGPoint(x: randomX, y: randomY))
            stars.append(newStar)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let index = stars.firstIndex(where: { $0.id == newStar.id }) {
                    stars[index].scale = 2.0
                    stars[index].opacity = 0.0
                    stars[index].hue = randomHue
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                stars.removeAll(where: {$0.id == newStar.id })
            }
        }
        
        /// stop the timer after a certain duration
        ///
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
            timer.invalidate()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StarsBlinkView()
            .preferredColorScheme(.dark)
    }
}

// We've created star shape!
struct Star: Shape {
    
    func path(in rect: CGRect) -> Path {
        let (x, y, width, height) = rect.centeredSquare.flatten()
        let lowerPoint = CGPoint(x: x + width / 2, y: y + height)
        
        let path = Path { p in
            p.move(to: lowerPoint)
            p.addArc(center: CGPoint(x: x, y: (y + height)),
                     radius: (width / 2),
                     startAngle: .A360,
                     endAngle: .A270,
                     clockwise: true)
            p.addArc(center: CGPoint(x: x, y: y),
                     radius: (width / 2),
                     startAngle: .A90,
                     endAngle: .zero,
                     clockwise: true)
            
            p.addArc(center: CGPoint(x: x + width, y: y),
                     radius: (width / 2),
                     startAngle: .A180,
                     endAngle: .A90,
                     clockwise: true)

            p.addArc(center: CGPoint(x: x + width, y: y + height),
                     radius: (width / 2),
                     startAngle: .A270,
                     endAngle: .A180,
                     clockwise: true)

        }
        
        return path
    }
    
}

// Let add some useful function or extension

extension CGRect {
    var center: CGPoint {
        CGPoint(x: self.midX, y: self.midY)
    }
    
    var centeredSquare: CGRect {
        let width = ceil(min(size.width, size.height))
        let height = width
        
        let newOrigin = CGPoint(x: origin.x + (size.width - width) / 2, y: origin.y + (size.height - height) / 2)
        let newSize = CGSize(width: width, height: height)
        return CGRect(origin: newOrigin, size: newSize)
    }
    
    func flatten() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        return (origin.x, origin.y, size.width, size.height)
    }
}

extension Angle {
    static let A180 = Angle(radians: .pi)
    static let A90 = Angle(radians: .pi / 2)
    static let A270 = Angle(radians: (.pi / 2) * 3)
    static let A360 = Angle(radians: .pi * 2)
}
