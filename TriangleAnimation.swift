//
//  ContentView.swift
//  ShapesFun
//
//  Created by Vishal Paliwal on 22/01/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var isAnimating = false
    @State var scale = 1
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
//            ZStack {
//
//                Triangle()
//                    .stroke(lineWidth: 1)
//                    .fill(LinearGradient(colors: [.red, .green, .blue], startPoint: .leading, endPoint: .trailing))
//                    .frame(width: 40, height: 40, alignment: .center)
//                    .scaleEffect(isAnimating ? CGFloat(scale) : 0)
//                    .offset(x: isAnimating ? 100 : -100)
//                    .opacity(isAnimating ? 1 : 0.2)
//                    .animation(Animation.easeOut(duration: 2.5).repeatForever(autoreverses: true), value: isAnimating)
//
//                Triangle()
//                    .stroke(lineWidth: 1.1)
//                    .fill(LinearGradient(colors: [.blue, .green, .yellow], startPoint: .leading, endPoint: .trailing))
//                    .frame(width: 80, height: 80, alignment: .center)
//                    .scaleEffect(isAnimating ? CGFloat(scale) : 0)
//                    .offset(x: isAnimating ? 100 : -100)
//                    .opacity(isAnimating ? 0.9 : 0.3)
//                    .animation(Animation.easeOut(duration: 2.5).repeatForever(autoreverses: true).delay(0.1), value: isAnimating)
//
//
//                Triangle()
//                    .stroke(lineWidth: 1.2)
//                    .fill(LinearGradient(colors: [.yellow, .pink, .blue], startPoint: .leading, endPoint: .trailing))
//                    .frame(width: 120, height: 120, alignment: .center)
//                    .scaleEffect(isAnimating ? CGFloat(scale) : 0)
//                    .offset(x: isAnimating ? 100 : -100)
//                    .opacity(isAnimating ? 0.8 : 0.4)
//                    .animation(Animation.easeOut(duration: 2.5).repeatForever(autoreverses: true).delay(0.2), value: isAnimating)
//
//
//                Triangle()
//                    .stroke(lineWidth: 1.3)
//                    .fill(LinearGradient(colors: [.blue, .purple, .green], startPoint: .leading, endPoint: .trailing))
//                    .frame(width: 160, height: 160, alignment: .center)
//                    .scaleEffect(isAnimating ? CGFloat(scale) : 0)
//                    .offset(x: isAnimating ? 100 : -100)
//                    .opacity(isAnimating ? 0.7 : 0.5)
//                    .animation(Animation.easeOut(duration: 2.5).repeatForever(autoreverses: true).delay(0.3), value: isAnimating)
//
//
//                Triangle()
//                    .stroke(lineWidth: 1.4)
//                    .fill(LinearGradient(colors: [.green, .blue, .cyan], startPoint: .leading, endPoint: .trailing))
//                    .frame(width: 220, height: 220, alignment: .center)
//                    .scaleEffect(isAnimating ? CGFloat(scale) : 0)
//                    .offset(x: isAnimating ? 100 : -100)
//                    .opacity(isAnimating ? 0.6 : 0.6)
//                    .animation(Animation.easeOut(duration: 2.5).repeatForever(autoreverses: true).delay(0.4), value: isAnimating)
//
//                Triangle()
//                    .stroke(lineWidth: 1.5)
//                    .fill(LinearGradient(colors: [.cyan, .orange, .teal], startPoint: .leading, endPoint: .trailing))
//                    .frame(width: 260, height: 260, alignment: .center)
//                    .scaleEffect(isAnimating ? CGFloat(scale) : 0)
//                    .offset(x: isAnimating ? 100 : -100)
//                    .opacity(isAnimating ? 0.5 : 0.7)
//                    .animation(Animation.easeOut(duration: 2.5).repeatForever(autoreverses: true).delay(0.5), value: isAnimating)
//
//                Triangle()
//                    .stroke(lineWidth: 1.6)
//                    .fill(LinearGradient(colors: [.teal, .mint, .white], startPoint: .leading, endPoint: .trailing))
//                    .frame(width: 320, height: 320, alignment: .center)
//                    .scaleEffect(isAnimating ? CGFloat(scale) : 0)
//                    .offset(x: isAnimating ? 100 : -100)
//                    .opacity(isAnimating ? 0.4 : 0.8)
//                    .animation(Animation.easeOut(duration: 2.5).repeatForever(autoreverses: true).delay(0.6), value: isAnimating)
//
//                Triangle()
//                    .stroke(lineWidth: 1.7)
//                    .fill(LinearGradient(colors: [.black, .teal, .blue], startPoint: .leading, endPoint: .trailing))
//                    .frame(width: 420, height: 420, alignment: .center)
//                    .scaleEffect(isAnimating ? CGFloat(scale) : 0)
//                    .offset(x: isAnimating ? 100 : -100)
//                    .opacity(isAnimating ? 0.3 : 0.9)
//                    .animation(Animation.easeOut(duration: 2.5).repeatForever(autoreverses: true).delay(0.7), value: isAnimating)
//
//                Triangle()
//                    .stroke(lineWidth: 1.8)
//                    .fill(LinearGradient(colors: [.mint, .black, .brown], startPoint: .leading, endPoint: .trailing))
//                    .frame(width: 520, height: 520, alignment: .center)
//                    .scaleEffect(isAnimating ? CGFloat(scale) : 0)
//                    .offset(x: isAnimating ? 100 : -100)
//                    .opacity(isAnimating ? 0.2 : 1)
//                    .animation(Animation.easeOut(duration: 2.5).repeatForever(autoreverses: true).delay(0.8), value: isAnimating)
//
//
//            }
            /// Optimize code using single For-Each statement 
            ZStack {
                ForEach(0..<8) { index in
                    let triangle = Triangle()

                    triangle.stroke(lineWidth: 1 + Double(index) * 0.1)
                        .fill(LinearGradient(colors: color(at: index), startPoint: .leading, endPoint: .trailing))
                        .frame(width: 40 + Double(index) * 60, height: 40 + Double(index) * 60, alignment: .center)
                        .scaleEffect(isAnimating ? CGFloat(scale) : 0)
                        .offset(x: isAnimating ? 100 : -100)
                        .opacity(isAnimating ? 1 - Double(index) * 0.1 : 0.2 + Double(index) * 0.1)
                        .animation(Animation.easeOut(duration: 2.5).repeatForever(autoreverses: true).delay(Double(index) * 0.1), value: isAnimating)
//                        .animation(Animation.interpolatingSpring(stiffness: 15, damping: 3).repeatForever(autoreverses: true).delay(Double(index) * 0.1), value: isAnimating)

                }
            }

            
        }
        
        .onAppear {
            isAnimating.toggle()
            scale = 2
        }
    }
    
    func color(at index: Int) -> [Color] {
        switch index {
        case 0:
            return [.red, .green, .blue]
        case 1:
            return [.blue, .green, .yellow]
        case 2:
            return [.yellow, .pink, .blue]
        case 3:
            return [.blue, .purple, .green]
        case 4:
            return [.green, .blue, .cyan]
        case 5:
            return [.cyan, .orange, .teal]
        case 6:
            return [.teal, .mint, .white]
        case 7:
            return [.black, .teal, .blue]
        default:
            return [.mint, .black, .brown]
        }
        return [.blue, .purple, .green]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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

struct Triangle_Previews: PreviewProvider {
    static var previews: some View {
        Triangle()
            .preferredColorScheme(.dark)
            .frame(width: 500, height: 500, alignment: .center)
            .previewLayout(.sizeThatFits)
    }
}
