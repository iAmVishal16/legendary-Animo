//
//  ContentView.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 23/08/23.
//

import SwiftUI

// Helper view to ensure detail views are properly centered and ignore safe areas
struct CenteredDetailView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Color("BgColor")
                .ignoresSafeArea(.all)
            
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentView: View {
    
    struct DemoItem: Identifiable {
        let id = UUID()
        let row: RowView
        let destination: AnyView
        let date: String?
        let hasDateHeader: Bool // Whether the source file has a creation date header
    }
    
    // Helper to wrap destination views with proper centering
    private func wrappedDestination<Content: View>(@ViewBuilder content: () -> Content) -> AnyView {
        AnyView(CenteredDetailView(content: content))
    }
    
    // Latest first (add new items at the top)
    private var demos: [DemoItem] {
        [
            // Latest animations
            DemoItem(row: RowView(icon: "🌀", title: "Parallax Carousel", desc: "Drag the 3D ring of photos with parallax"), destination: wrappedDestination {
                ParallaxCarouselView()
            }, date: "Nov 8, 2025", hasDateHeader: false),
            DemoItem(row: RowView(icon: "🎛️", title: "Unique Loaders Grid", desc: "Multiple CSS-inspired loaders rebuilt in SwiftUI"), destination: wrappedDestination {
                UniqueLoadersGridView()
            }, date: "Nov 8, 2025", hasDateHeader: false),
            // Missing animations added
            DemoItem(row: RowView(icon: "🪐", title: "Multi Orbit View", desc: "Interactive planet & satellite orbits"), destination: wrappedDestination {
                MultiOrbitView(satellites: (0..<3).map { _ in Satellite.random() }, planetRadius: 1.5)
            }, date: "May 15, 2025", hasDateHeader: false), // No date header in file
            DemoItem(row: RowView(icon: "🔘", title: "Micro Interaction Button", desc: "Loading states & morphing"), destination: wrappedDestination {
                VStack(spacing: 24) {
                    MicroInteractionButton(icon: "applelogo", title: "Sign in with Apple") {
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                    }
                    MicroInteractionButton(icon: "heart.fill", title: "Like") {
                        try? await Task.sleep(nanoseconds: 1_500_000_000)
                    }
                }
                .padding()
            }, date: "May 12, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "⚫️", title: "Circles 3D", desc: "Animated 3D circles"), destination: wrappedDestination {
                Circles3D()
            }, date: "May 8, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "💫", title: "Rotating Dots", desc: "Orbital rotating dots"), destination: wrappedDestination {
                RotatingDotsView()
            }, date: "May 5, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "⚡", title: "Flashing Button", desc: "Shimmer effect button"), destination: wrappedDestination {
                FlashingView()
            }, date: "May 3, 2025", hasDateHeader: false), // No date header in file
            DemoItem(row: RowView(icon: "⚪️", title: "Dot Field Wave (Interactive)", desc: "Physics-based wave propagation"), destination: wrappedDestination {
                FullScreenDotFieldWave()
                    .ignoresSafeArea()
            }, date: "Oct 4, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "🫧", title: "Floating View", desc: "Organic floating particles"), destination: wrappedDestination {
                FloatingView()
            }, date: "May 1, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "⭕️", title: "3D Ring animation", desc: "Circles animation in Z axis"), destination: wrappedDestination {
                RingsAnimationView()
            }, date: "Apr 17, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "⦿", title: "Circles animation", desc: "Moving Circles animation in center with delay"), destination: wrappedDestination {
                CirclesView()
            }, date: "Apr 14, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "⏳", title: "Countdown Timer for Fitness", desc: "A perfect fit in fitness app"), destination: wrappedDestination {
                TimerView()
            }, date: "Apr 9, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "🔺", title: "Triangle Animation", desc: "Multiple Gradient tringle shape scale animation"), destination: wrappedDestination {
                TriangleAnimationView()
            }, date: "Apr 6, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "𑗊", title: "MultiShapes 3D animation with rotation", desc: "Multiple shapes rotation"), destination: wrappedDestination {
                TriangleMultiShapeUIView()
            }, date: "Mar 16, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "᠅", title: "Dots Circle Animation", desc: "Dashed circles smooth animation"), destination: wrappedDestination {
                DotsAnimPreview()
            }, date: "Mar 10, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "🌇", title: "Google Photos Logo Animation", desc: "Logo using trim & offset"), destination: wrappedDestination {
                GooglePhotosLogoAnim()
            }, date: "Mar 6, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "🔳", title: "Rectangle Rotation animation", desc: "Scale, offset & ease"), destination: wrappedDestination {
                RectRotationView()
            }, date: "Mar 2, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "🪫", title: "Battery Waves + Bubbles", desc: "Wave fill + bubbles"), destination: wrappedDestination {
                BatteryAnimation()
            }, date: "Feb 20, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "◎", title: "3D Circles animation", desc: "Time sequence z,y,z"), destination: wrappedDestination {
                CiclesTransViewOptimizeView()
            }, date: "Feb 12, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "✨", title: "Blinking Stars Animation", desc: "Particle field"), destination: wrappedDestination {
                StarsBlinkView()
            }, date: "Jan 30, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "꩜", title: "Spiral Animation", desc: "Dynamic spiral"), destination: wrappedDestination {
                SpiralView()
            }, date: "Jan 22, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "🔥", title: "Fireworks Animation", desc: "Explosive particles"), destination: wrappedDestination {
                FireworksView()
            }, date: "Jan 15, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "✷", title: "Loader Animation v1", desc: "Magnetic hue rotation"), destination: wrappedDestination {
                CirclesRotations(count: 5).frame(width: 100, height: 100)
            }, date: "Jan 10, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "🧲", title: "Magnetic dots Animation", desc: "Hue rotation variations"), destination: wrappedDestination {
                DotsAnimationView()
            }, date: "Jan 7, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "⿲", title: "Bar Loader View", desc: "Indeterminate bar"), destination: wrappedDestination {
                BarLoaderView()
            }, date: "Jan 3, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "🏷️", title: "Chips Drag & Drop", desc: "Falling chips with drag reordering"), destination: wrappedDestination {
                ChipsView()
            }, date: "Jan 1, 2025", hasDateHeader: true),
            // Additional chip animations from ChipsDrags.swift
            DemoItem(row: RowView(icon: "🏷️", title: "Chips V2 (Optimized)", desc: "Drop-in chips with staggered animation"), destination: wrappedDestination {
                ChipsViewV2()
            }, date: "Oct 1, 2025", hasDateHeader: true),
            DemoItem(row: RowView(icon: "🍃", title: "Falling Chips Physics", desc: "Realistic gravity & stacking"), destination: wrappedDestination {
                FallingChipsView()
            }, date: "Oct 1, 2025", hasDateHeader: true)
        ]
    }
    
    private var sections: [(header: String, items: [(index: Int, date: String)])] {
        // Separate items without date headers from others
        var noHeaderItems: [(Int, String)] = []
        var headerItems: [(Int, String)] = []
        
        for (idx, demo) in demos.enumerated() {
            let dateStr = demo.date ?? ""
            if demo.hasDateHeader {
                headerItems.append((idx, dateStr))
            } else {
                noHeaderItems.append((idx, dateStr))
            }
        }
        
        // Group items with date headers by month-year
        var grouped: [(String, [(Int, String)])] = []
        var headerToIndex: [String: Int] = [:]
        for item in headerItems {
            let header = monthHeader(from: item.1)
            if let existing = headerToIndex[header] {
                grouped[existing].1.append(item)
            } else {
                headerToIndex[header] = grouped.count
                grouped.append((header, [item]))
            }
        }
        
        // Add items without date headers as a separate section at the end
        if !noHeaderItems.isEmpty {
            grouped.append(("OTHER", noHeaderItems))
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
