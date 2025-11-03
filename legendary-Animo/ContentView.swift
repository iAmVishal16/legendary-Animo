//
//  ContentView.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 23/08/23.
//

import SwiftUI

struct ContentView: View {
    
    struct DemoItem: Identifiable {
        let id = UUID()
        let row: RowView
        let destination: AnyView
        let date: String?
    }
    
    // Latest first (add new items at the top)
    private var demos: [DemoItem] {
        [
            // Missing animations added
            DemoItem(row: RowView(icon: "🪐", title: "Multi Orbit View", desc: "Interactive planet & satellite orbits"), destination: AnyView(
                MultiOrbitView(satellites: (0..<3).map { _ in Satellite.random() }, planetRadius: 1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            ), date: "May 15, 2025"),
            DemoItem(row: RowView(icon: "🔘", title: "Micro Interaction Button", desc: "Loading states & morphing"), destination: AnyView(
                VStack(spacing: 24) {
                    MicroInteractionButton(icon: "applelogo", title: "Sign in with Apple") {
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                    }
                    MicroInteractionButton(icon: "heart.fill", title: "Like") {
                        try? await Task.sleep(nanoseconds: 1_500_000_000)
                    }
                }
                .padding()
            ), date: "May 12, 2025"),
            DemoItem(row: RowView(icon: "⚫️", title: "Circles 3D", desc: "Animated 3D circles"), destination: AnyView(Circles3D()), date: "May 8, 2025"),
            DemoItem(row: RowView(icon: "💫", title: "Rotating Dots", desc: "Orbital rotating dots"), destination: AnyView(RotatingDotsView()), date: "May 5, 2025"),
            DemoItem(row: RowView(icon: "⚡", title: "Flashing Button", desc: "Shimmer effect button"), destination: AnyView(FlashingView()), date: "May 3, 2025"),
            DemoItem(row: RowView(icon: "⚪️", title: "Dot Field (Interactive)", desc: "Full-screen SpriteKit dot field"), destination: AnyView(FullScreenDotFieldContinuous()), date: "May 10, 2025"),
            DemoItem(row: RowView(icon: "🫧", title: "Floating View", desc: "Organic floating particles"), destination: AnyView(FloatingView()), date: "May 1, 2025"),
            DemoItem(row: RowView(icon: "⭕️", title: "3D Ring animation", desc: "Circles animation in Z axis"), destination: AnyView(RingsAnimationView()), date: "Apr 17, 2025"),
            DemoItem(row: RowView(icon: "⦿", title: "Circles animation", desc: "Moving Circles animation in center with delay"), destination: AnyView(CirclesView()), date: "Apr 14, 2025"),
            DemoItem(row: RowView(icon: "⏳", title: "Countdown Timer for Fitness", desc: "A perfect fit in fitness app"), destination: AnyView(TimerView()), date: "Apr 9, 2025"),
            DemoItem(row: RowView(icon: "🔺", title: "Triangle Animation", desc: "Multiple Gradient tringle shape scale animation"), destination: AnyView(TriangleAnimationView()), date: "Apr 6, 2025"),
            DemoItem(row: RowView(icon: "𑗊", title: "MultiShapes 3D animation with rotation", desc: "Multiple shapes rotation"), destination: AnyView(TriangleMultiShapeUIView()), date: "Mar 16, 2025"),
            DemoItem(row: RowView(icon: "᠅", title: "Dots Circle Animation", desc: "Dashed circles smooth animation"), destination: AnyView(DotsAnimPreview()), date: "Mar 10, 2025"),
            DemoItem(row: RowView(icon: "🌇", title: "Google Photos Logo Animation", desc: "Logo using trim & offset"), destination: AnyView(GooglePhotosLogoAnim()), date: "Mar 6, 2025"),
            DemoItem(row: RowView(icon: "🔳", title: "Rectangle Rotation animation", desc: "Scale, offset & ease"), destination: AnyView(RectRotationView()), date: "Mar 2, 2025"),
            DemoItem(row: RowView(icon: "🪫", title: "Battery Waves + Bubbles", desc: "Wave fill + bubbles"), destination: AnyView(BatteryAnimation()), date: "Feb 20, 2025"),
            DemoItem(row: RowView(icon: "◎", title: "3D Circles animation", desc: "Time sequence z,y,z"), destination: AnyView(CiclesTransViewOptimizeView()), date: "Feb 12, 2025"),
            DemoItem(row: RowView(icon: "✨", title: "Blinking Stars Animation", desc: "Particle field"), destination: AnyView(StarsBlinkView()), date: "Jan 30, 2025"),
            DemoItem(row: RowView(icon: "꩜", title: "Spiral Animation", desc: "Dynamic spiral"), destination: AnyView(SpiralView()), date: "Jan 22, 2025"),
            DemoItem(row: RowView(icon: "🔥", title: "Fireworks Animation", desc: "Explosive particles"), destination: AnyView(FireworksView()), date: "Jan 15, 2025"),
            DemoItem(row: RowView(icon: "✷", title: "Loader Animation v1", desc: "Magnetic hue rotation"), destination: AnyView(CirclesRotations(count: 5).frame(width: 100, height: 100)), date: "Jan 10, 2025"),
            DemoItem(row: RowView(icon: "🧲", title: "Magnetic dots Animation", desc: "Hue rotation variations"), destination: AnyView(DotsAnimationView()), date: "Jan 7, 2025"),
            DemoItem(row: RowView(icon: "⿲", title: "Bar Loader View", desc: "Indeterminate bar"), destination: AnyView(BarLoaderView()), date: "Jan 3, 2025"),
            DemoItem(row: RowView(icon: "🏷️", title: "Chips Drag & Drop", desc: "Falling chips with drag reordering"), destination: AnyView(ChipsView()), date: "Jan 1, 2025")
        ]
    }
    
    private var sections: [(header: String, items: [(index: Int, date: String)])] {
        // Group demos by month-year derived from the date string, preserving order (latest first)
        var grouped: [(String, [(Int, String)])] = []
        var headerToIndex: [String: Int] = [:]
        for (idx, demo) in demos.enumerated() {
            let dateStr = demo.date ?? ""
            let header = monthHeader(from: dateStr)
            if let existing = headerToIndex[header] {
                grouped[existing].1.append((idx, dateStr))
            } else {
                headerToIndex[header] = grouped.count
                grouped.append((header, [(idx, dateStr)]))
            }
        }
        return grouped
    }

    private func monthHeader(from dateString: String) -> String {
        guard !dateString.isEmpty else { return "LATEST" }
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "MMM d, yyyy"
        if let date = df.date(from: dateString) {
            let out = DateFormatter()
            out.locale = df.locale
            out.dateFormat = "MMM yyyy"
            return out.string(from: date).uppercased()
        }
        return "LATEST"
    }
        
    @State private var selection: Int? = 0

    var body: some View {

        NavigationView {
            ZStack (alignment: .top){
                Color("BgColor")
                    .edgesIgnoringSafeArea(.all)
                
                List(selection: $selection) {
                    ForEach(Array(sections.enumerated()), id: \.offset) { _, section in
                        Section {
                            ForEach(section.items, id: \.index) { item in
                                NavigationLink {
                                    demos[item.index].destination
                                } label: {
                                    VStack(alignment: .leading, spacing: 6) {
                                        // Date above the title, subtle
                                        if !item.date.isEmpty {
                                            Text(item.date)
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                        // Keep original RowView design occupying full width
                                        demos[item.index].row
                                    }
                                }
                            }
                        } header: {
                            Text(section.header)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    // Footer
                    VStack(spacing: 8) {
                        Text("A collection of micro-interactions and UI experiments built with SwiftUI, UIKit, and Metal by Vishal Paliwal @iamvishal16.")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.top, 24)
                        Text("Say hi: paliwalvishal16@gmail.com")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 24)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }
            }
            .padding(.top, 8)
            .listStyle(InsetGroupedListStyle())
            .listRowSeparator(.hidden)
            .listRowSpacing(8)
            .navigationTitle("Legendary-Animo")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // getDestination removed in favor of typed demo mapping above
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
