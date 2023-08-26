//
//  CiclesTransView.swift
//  ShapeAnimation
//
//  Created by Vishal Paliwal on 19/06/23.
//

import SwiftUI

// #pragma MARK: Variation 1st
struct CiclesTransView: View {
    
    @State private var animate = false
    
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [1, 5]))
                .frame(width: 40)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 0, z: 0))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever(), value: animate)
            
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .frame(width: 80)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 0, z: 0))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever().delay(0.1), value: animate)


            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [1, 10]))
                .frame(width: 120)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 0, z: 0))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever().delay(0.2), value: animate)

            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [1, 0]))
                .frame(width: 160)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 0, z: 0))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever().delay(0.3), value: animate)

            
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [1, 10]))
                .frame(width: 200)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 0, z: 0))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever().delay(0.4), value: animate)
            
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [1, 0]))
                .frame(width: 240)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 0, z: 0))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever().delay(0.5), value: animate)

            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [1, 10]))
                .frame(width: 280)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 0, z: 0))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever().delay(0.6), value: animate)

            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [1, 0]))
                .frame(width: 320)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 0, z: 0))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever().delay(0.7), value: animate)
            

        }
        .rotation3DEffect(.degrees(0), axis: (x: 1, y: 1, z: 1))
        .onAppear {
            animate.toggle()
        }
    }
}

struct CiclesTransView_Previews: PreviewProvider {
    static var previews: some View {
        CiclesTransView()
            .preferredColorScheme(.dark)
    }
}

// #pragma MARK: Variation Final
struct CiclesTransView3D: View {
    
    @State private var animate = false
    
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [1, 5]))
                .frame(width: 40)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 1, z: 1))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever(), value: animate)
            
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .frame(width: 80)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 1, z: 1))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever().delay(0.1), value: animate)


            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [1, 10]))
                .frame(width: 120)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 1, z: 1))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever().delay(0.2), value: animate)

            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [1, 0]))
                .frame(width: 160)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 1, z: 1))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever().delay(0.3), value: animate)

            
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [1, 10]))
                .frame(width: 200)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 1, z: 1))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever().delay(0.4), value: animate)
            
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [1, 0]))
                .frame(width: 240)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 1, z: 1))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever().delay(0.5), value: animate)

            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [1, 10]))
                .frame(width: 280)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 1, z: 1))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever().delay(0.6), value: animate)

            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [1, 0]))
                .frame(width: 320)
                .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 1, z: 1))
                .animation(.interpolatingSpring(stiffness: 8, damping: 30).repeatForever().delay(0.7), value: animate)
            

        }
        .rotation3DEffect(.degrees(0), axis: (x: 1, y: 1, z: 1))
        .onAppear {
            animate.toggle()
        }
    }
}

struct CiclesTransView3D_Previews: PreviewProvider {
    static var previews: some View {
        CiclesTransView3D()
            .preferredColorScheme(.dark)
    }
}


// #pragma MARK: Optimized Code
struct CiclesTransViewOptimizeView: View {
    @State private var animate = false
    @Binding var animType: ContentView.AnimationType
    @Binding var isActive: Bool

    var body: some View {
        ZStack {
            createCircle(width: 40, dash: [1, 5], delay: 0)
            
            createCircle(width: 80, dash: [], delay: 0.1)
            
            createCircle(width: 120, dash: [1, 10], delay: 0.2)
            
            createCircle(width: 160, dash: [1, 0], delay: 0.3)
            
            createCircle(width: 200, dash: [1, 10], delay: 0.4)
            
            createCircle(width: 240, dash: [1, 0], delay: 0.5)
            
            createCircle(width: 280, dash: [1, 10], delay: 0.6)
            
            createCircle(width: 320, dash: [1, 0], delay: 0.7)
        }
        .onAppear {
            animate.toggle()
        }
        .onTapGesture {
            animType = .rings
            isActive = true
        }
    }
    
    private func createCircle(width: CGFloat, dash: [CGFloat], delay: Double) -> some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: dash))
            .frame(width: width)
            .rotation3DEffect(.degrees(animate ? 360 : 0), axis: (x: 1, y: 1, z: 1))
            .animation(createAnimation(delay: delay), value: animate)
    }
    
    private func createAnimation(delay: Double) -> Animation {
        Animation.interpolatingSpring(stiffness: 8, damping: 30)
            .repeatForever()
            .delay(delay)
    }
}

struct CiclesTransViewOptimize_Previews: PreviewProvider {
    static var previews: some View {
        CiclesTransViewOptimizeView(animType: .constant(.rings), isActive: .constant(true))
            .preferredColorScheme(.dark)
    }
}
