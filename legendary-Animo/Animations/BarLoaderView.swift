//
//  BarLoaderView.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 25/04/24.
//

import SwiftUI

struct BarLoaderView: View {
    
    @State private var animate: Bool = false
    @State private var selectedIndex: Int = 0
    
    let delays: [Double] = [0.0, 0.1, 0.2, 0.3, 0.4]
    
    var body: some View {
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            Circle()
                .fill(
                    LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 120)
//                .foregroundStyle(.cyan)
            
            HStack {
                ForEach(0..<delays.count, id: \.self) { index in
                    Capsule()
                        .frame(width: 4, height: self.animate ? 120 : 20)
                        .foregroundStyle(.white)
                        .animation(.linear.delay(self.delays[index]), value: self.animate)
                    
                }
            }
            .onAppear {
                self.startAnimation()
            }
        }
    }
    
    func opacity(for index: Int) -> Double {
        let distance = abs(index - selectedIndex)
        switch distance {
        case 0: return 1.0
        case 1: return 0.8
        case 2: return 0.6
        default: return 0.4
        }
    }
    
    func startAnimation() {
        
        Timer.scheduledTimer(withTimeInterval: 1.1, repeats: true) { timer in
            self.animate.toggle()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.animate.toggle()
                
                withAnimation {
                    selectedIndex = (selectedIndex + 1) % delays.count
                }
            }
        }
    }
}

#Preview {
    BarLoaderView()
}
