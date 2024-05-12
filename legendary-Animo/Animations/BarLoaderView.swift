//
//  BarLoaderView.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 25/04/24.
//

import SwiftUI

struct BarLoaderView: View {
    
    @State private var animate: Bool = false
    
    let delays: [Double] = [0.0, 0.1, 0.2, 0.3, 0.4]
    
    var body: some View {
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            HStack {
                ForEach(0..<delays.count, id: \.self) { index in
                    Rectangle()
                        .frame(width: 10, height: self.animate ? 120 : 20)
                        .animation(.linear.delay(self.delays[index]), value: self.animate)
                    
                }
            }
            .foregroundStyle(.green.opacity(0.8))
            .onAppear {
                self.startAnimation()
            }
        }
    }
    
    func startAnimation() {
        
        Timer.scheduledTimer(withTimeInterval: 1.1, repeats: true) { timer in
            self.animate.toggle()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.animate.toggle()
            }
        }
    }
}

#Preview {
    BarLoaderView()
}
