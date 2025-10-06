//
//  FloatingView.swift
//  InstantComponents
//
//  Created by Vishal Paliwal on 05/12/24.
//

import SwiftUI

struct FloatingButtons: Identifiable {
    var id = UUID().uuidString
    var color: Color
    var icon: String
}

struct FloatingView: View {
    
    @State private var animate: Bool = false
    @State private var buttons:[FloatingButtons] = [
        FloatingButtons(color: .green, icon: "face.smiling.inverse"),
        FloatingButtons(color: .blue, icon: "message.fill"),
        FloatingButtons(color: .purple, icon: "bookmark.fill"),
        FloatingButtons(color: .red, icon: "heart.fill"),
    ]
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            Color.white
                .ignoresSafeArea()
                        
                ForEach(buttons.indices, id: \.self) { index in
                    Circle()
                        .foregroundStyle(buttons[index].color)
                        .frame(height: 80)
                        .overlay {
                            Image(systemName: buttons[index].icon)
                                .font(.largeTitle)
                                .fontDesign(.rounded)
                        }
                        .opacity(animate ? 1 : 0)
                        .scaleEffect(animate ? 1 : 0)
                        .rotationEffect(.degrees(animate ? 360 : 0))
                        .offset(x: animate ? CGFloat(index) * 100 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: animate)
                }
            
            Circle()
                .foregroundStyle(.ultraThinMaterial)
                .frame(height: 80)
                .overlay {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .fontDesign(.rounded)
                }
                .rotationEffect(.degrees(animate ? 45 : 0))
                .offset(x: animate ? 400 : 0)
//                .animation(.bouncy, value: animate)
                .onTapGesture(perform: {
                    withAnimation(.spring) {
                        animate.toggle()
                    }
                })

        }
    }
}

#Preview {
    FloatingView()
}
