//
//  ContentView.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 23/08/23.
//

import SwiftUI

struct ContentView: View {
    
    enum AnimationType: Int {
        case rings = 0
        case circles
        case countDownTimer
        case triangle
        case multiShape
        case dots
        case logoG
        case rect
        case battery
        case circlesV2
        case stars
        case spiral
        case fireworks
    }
    
    let rows:[RowView] = [
        RowView(icon: "⭕️", title: "3D Ring animation", desc: "Circles animation in Z axis"),
        RowView(icon: "⦿", title: "Circles animation", desc: "Moving Circles animation in center with delay"),
        RowView(icon: "⏳", title: "Countdown Timer for Fitness", desc: "A perfect fit in fitness app"),
        RowView(icon: "🔺", title: "Triangle Animation", desc: "Multiple Gradient tringle shape scale animation"),
        RowView(icon: "𑗊", title: "MultiShapes 3D animation with rotation", desc: "Multiple shapes rotation"),
        RowView(icon: "᠅", title: "Dots Circle Animation", desc: "Dashed circles smooth animation using easeinout"),
        RowView(icon: "🌇", title: "Google Photos Logo Animation", desc: "Google photos Logo animation using trim and offset"),
        RowView(icon: "🔳", title: "Rectangle Rotation animation", desc: "Rectangle animation using scale, offset and easeinout curve"),
        RowView(icon: "🪫", title: "Battery fill Waves with Bubbles animation", desc: "Rectangle animation using scale, offset and easeinout curve"),
        RowView(icon: "◎", title: "3D Circles animation", desc: "Time sequence, z,y,z axis"),
        RowView(icon: "✨", title: "Blinking Stars Animation", desc: "Control the birth rate, hue, and unleash your creative freedom."),
        RowView(icon: "꩜", title: "Spriral Animation", desc: "Control the birth rate, hue, and unleash your creative freedom."),
        RowView(icon: "🔥", title: "Fireworks Animation", desc: "Control the birth rate, hue, and unleash your creative freedom.")
        ]
        
    @State private var selection: Int? = 0
    @State var animType: ContentView.AnimationType = .rings
    @State var isActive: Bool = false

    var body: some View {

        NavigationView {
            ZStack (alignment: .top){
                Color("BgColor")
                    .edgesIgnoringSafeArea(.all)
                
                List(selection: $selection) {
                    ForEach(rows.indices, id: \.self) { index in
                        NavigationLink {
                            getDestination(with: index)
                        } label: {
                            rows[index]
                        }

                    }
                }
            }
            .padding(.top, 8)
            .listStyle(InsetGroupedListStyle())
            .listRowSeparator(.hidden)
            .listRowSpacing(8)
            .navigationTitle("Legendary-Animo")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
    
    @ViewBuilder
    private func getDestination(with index: Int) -> some View {
        let type = AnimationType(rawValue: index)
        
        switch type {
        case .rings:
            RingsAnimationView()
        case .circles:
            CirclesView()
        case .countDownTimer:
            TimerView()
        case .triangle:
            TriangleAnimationView()
        case .multiShape:
            TriangleMultiShapeUIView()
        case .dots:
            DotsAnimPreview()
        case .logoG:
            GooglePhotosLogoAnim()
        case .rect:
            RectRotationView()
        case .battery:
            BatteryAnimation()
        case .circlesV2:
            CiclesTransViewOptimizeView(animType: $animType, isActive: $isActive)
        case .stars:
            StarsBlinkView()
        case .spiral:
            SpiralView()
        case .fireworks:
            FireworksView()
        case nil:
            StarsBlinkView()
        }
    }
    
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
