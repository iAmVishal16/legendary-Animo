//
//  ContentView.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 23/08/23.
//

import SwiftUI

struct ContentView: View {
    
    let rows:[RowView] = [
        RowView(icon: "⭕️", title: "3D Ring animation", desc: "Circles animation in Z axis"),
        RowView(icon: "⏳", title: "Countdown Timer for Fitness", desc: "A perfect fit in fitness app"),
        RowView(icon: "🔺", title: "Triangle Animation", desc: "Multiple Gradient tringle shape scale animation"),
        RowView(icon: "𑗊", title: "MultiShapes 3D animation with rotation", desc: "Multiple shapes rotation"),
        RowView(icon: "᠅", title: "Dots Circle Animation", desc: "Dashed circles smooth animation using easeinout"),
        RowView(icon: "🌇", title: "Google Photos Logo Animation", desc: "Google photos Logo animation using trim and offset"),
        RowView(icon: "🔳", title: "Rectangle Rotation animation", desc: "Rectangle animation using scale, offset and easeinout curve"),
        RowView(icon: "🪫", title: "Battery fill Waves with Bubbles animation", desc: "Rectangle animation using scale, offset and easeinout curve")

        ]
        
        @State private var selection = 0
    
    var body: some View {

        NavigationView {
            ZStack (alignment: .top){
                Color("BgColor")
                    .edgesIgnoringSafeArea(.all)
                
                List {
                    ForEach(rows.indices, id: \.self) { index in
                        rows[index]
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
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
