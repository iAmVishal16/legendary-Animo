//
//  RotatingDotsView.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 14/04/24.
//

import SwiftUI

struct RotatingDotsView2: View {
    @State private var offset: CGFloat = -130
        @State private var rotation: Double = 0.0
        
        var body: some View {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                ZStack {
                    ForEach(0 ..< 40) { i in
                        Rectangle()
                            .frame(width: 20, height: 20)
                            .rotation3DEffect(.degrees(45), axis: (x: 0.0, y: 1.0, z: 0.0))
                            .foregroundColor(.cyan)
                            .offset(
                                x: offset * cos(.pi / 10 * CGFloat(i)),
                                y: offset * sin(.pi / 10 * CGFloat(i))
                            )
                            .animation(
                                Animation.easeInOut(duration: 0.5)
                                    .repeatForever(autoreverses: true)
                                    .delay(0.05 * Double(i)),
                                value: offset
                            )
                            .rotationEffect(.degrees(360 / 40 * Double(i)))
                            .hueRotation(.degrees(rotation))
                    }
                }
                .rotationEffect(.degrees(rotation))
                .animation(Animation.linear(duration: 5).repeatForever(), value: rotation)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5)) {
                    offset += 130
                }
                rotation = 360
            }
        }
}

#Preview("Exp2") {
    RotatingDotsView2()
}

struct RotatingDotsView1: View {
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
                           .rotation3DEffect(.degrees(45), axis: (x: 0.0, y: 1.0, z: 0.0))
                           .foregroundColor(.cyan)
                           .offset(
                               x: offset * cos(.pi / 10 * CGFloat(i)),
                               y: offset * sin(.pi / 10 * CGFloat(i))
                           )
                           .animation(
                               Animation.easeInOut(duration: 0.5)
                                   .repeatForever(autoreverses: true)
                                   .delay(0.05 * Double(i)),
                               value: offset
                           )
                           .rotationEffect(.degrees(360 / 40 * Double(i)))
                           .hueRotation(.degrees(rotation))
                   }
               }
               .rotationEffect(.degrees(rotation))
               .animation(Animation.linear(duration: 5).repeatForever(), value: rotation)
           }
           .onAppear {
               withAnimation(.easeInOut(duration: 1.5)) {
                   offset += 130
               }
               rotation = 360
           }
       }
}

#Preview("Exp1") {
    RotatingDotsView1()
}

struct RotatingDotsView: View {
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
                        .rotation3DEffect(.degrees(45), axis: (x: 0.0, y: 1.0, z: 0.0))
                        .foregroundColor(.cyan)
                        .offset(x: offset, y: offset)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.1 * Double(20 - i)), value: offset)
                        .rotationEffect(.degrees(360 / 20 * Double(i)))
                        .hueRotation(.degrees(rotation))
                    
                    Rectangle()
                        .frame(width: 20, height: 20)
                        .rotation3DEffect(.degrees(45), axis: (x: 0.0, y: 1.0, z: 0.0))
                        .foregroundColor(.cyan)
                        .offset(x: offset * 0.5, y: offset * 0.5)
                        .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.1 * Double(20 - i)), value: offset)
                        .rotationEffect(.degrees(360 / 20 * Double(i)))
                        .hueRotation(.degrees(rotation))
                }
            }
            .rotationEffect(.degrees(rotation))
            .animation(Animation.linear(duration: 5).repeatForever(), value: rotation)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                offset += 130
            }
            rotation = 360
        }
    }
}

#Preview("Original") {
    RotatingDotsView()
}
