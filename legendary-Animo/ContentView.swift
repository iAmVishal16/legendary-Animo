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
        case countDownTimer
        case triangle
        case multiShape
        case dots
        case logoG
        case rect
        case battery
        case circles
        case stars
    }
    
    let rows:[RowView] = [
        RowView(icon: "⭕️", title: "3D Ring animation", desc: "Circles animation in Z axis"),
        RowView(icon: "⏳", title: "Countdown Timer for Fitness", desc: "A perfect fit in fitness app"),
        RowView(icon: "🔺", title: "Triangle Animation", desc: "Multiple Gradient tringle shape scale animation"),
        RowView(icon: "𑗊", title: "MultiShapes 3D animation with rotation", desc: "Multiple shapes rotation"),
        RowView(icon: "᠅", title: "Dots Circle Animation", desc: "Dashed circles smooth animation using easeinout"),
        RowView(icon: "🌇", title: "Google Photos Logo Animation", desc: "Google photos Logo animation using trim and offset"),
        RowView(icon: "🔳", title: "Rectangle Rotation animation", desc: "Rectangle animation using scale, offset and easeinout curve"),
        RowView(icon: "🪫", title: "Battery fill Waves with Bubbles animation", desc: "Rectangle animation using scale, offset and easeinout curve"),
        RowView(icon: "⏺", title: "3D Circles animation", desc: "Time sequence, z,y,z axis"),
        RowView(icon: "✨", title: "Blinking Stars Animation", desc: "Control the birth rate, hue, and unleash your creative freedom.")
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
                            let type = AnimationType(rawValue: index)
                            
                            switch type {
                            case .rings:
                                RingsAnimationView()
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
                            case .circles:
                                CiclesTransViewOptimizeView(animType: $animType, isActive: $isActive)
                            case .stars:
                                StarsBlinkView()
                            case .none:
                                StarsBlinkView()
                            }
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
    
    private func getDestination(with index: Int) -> any View {
        let type = AnimationType(rawValue: index)
        
        switch type {
        case .rings:
            return RingsAnimationView()
        case .countDownTimer:
            return TimerView()
        case .triangle:
            return TriangleAnimationView()
        case .multiShape:
            return TriangleMultiShapeUIView()
        case .dots:
            return DotsAnimPreview()
        case .logoG:
            return GooglePhotosLogoAnim()
        case .rect:
            return RectRotationView()
        case .battery:
            return BatteryAnimation()
        case .circles:
            return  CiclesTransViewOptimizeView(animType: $animType, isActive: $isActive)
        case .stars:
            return StarsBlinkView()
        case nil:
            break
        }
        
        return StarsBlinkView()
    }
    
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
