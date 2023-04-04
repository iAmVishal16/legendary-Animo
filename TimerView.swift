//
//  TimerView.swift
//  Fitness Timer
//
//  Created by Vishal Paliwal on 31/01/23.
//

import SwiftUI

struct TimerView: View {
    
    @State private var isAnimating = false
    let animation = Animation
            .linear(duration: 5)
            .repeatForever(autoreverses: false)
    @State var timeRemaining = 0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    Color.gray.opacity(0.6)
                )
                .foregroundStyle(.tertiary)
                .padding()
                .frame(width: 240, height: 240)
            
            Circle()
                .fill(
                    Color("BgColor")
                )
                .padding()
                .frame(width: 220, height: 220)
            
            
            Text(String(format: "%02d", timeRemaining))
                .onReceive(timer) { _ in
                    timeRemaining += 1
                    if timeRemaining >= 10 {
                        timeRemaining = 0
                    }
                }
                .font(.largeTitle)
                .fontWeight(.black)
            
        }
        .overlay {
            ZStack {
                Circle()
                    .trim(from: 0, to: isAnimating ? 1 : .leastNonzeroMagnitude)
                    .stroke(lineWidth: 16)
                    .foregroundColor(.cyan.opacity(0.5))
                    .frame(width: 190, height: 190)
                    .rotationEffect(.degrees(-90))
                
                Circle()
                    .trim(from: 0, to: isAnimating ? 1 : .leastNonzeroMagnitude)
                    .stroke(lineWidth: 8)
                    .foregroundColor(.cyan)
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
            }
            .overlay {
                ZStack {
                    Circle()
                        .frame(width: 4, height: 4)
                        .foregroundColor(.cyan)
                    Rectangle()
                        .frame(width: 120, height: 1)
                        .foregroundColor(.cyan)
                        .offset(x: -40)
                }
                .rotationEffect(Angle(degrees: 90))
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
//                .animation(Animation.linear(duration: 5).repeatForever(), value: isAnimating)
            }
            
        }
        .animation(animation, value: isAnimating)
        .onAppear {
            isAnimating.toggle()
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
