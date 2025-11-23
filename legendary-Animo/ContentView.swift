//
//  ContentView.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 23/08/23.
//

import SwiftUI
import Foundation

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
        let date: Date?
        let dateString: String
        let hasDateHeader: Bool // Whether the source file has a creation date header
        let filePath: String? // Path to the source file for date extraction
    }
    
    // Static date mapping extracted from file headers (DD/MM/YYYY format)
    private let dateMap: [String: (day: Int, month: Int, year: Int)] = [
        "ParallaxCarouselView": (8, 11, 2025),
        "UniqueLoadersGridView": (8, 11, 2025),
        "FullScreenDotFieldWave": (4, 10, 2025),
        "HapticFeedback": (4, 10, 2025),
        "FullScreenDotFieldContinuous": (2, 10, 2025),
        "Buttons": (6, 7, 2025),
        "Circles3D": (28, 9, 2025),
        "CiclesTransView3D": (19, 6, 2023),
        "ChipsDrags": (1, 10, 2025),
        "FloatingView": (5, 12, 2024),
        "TriangleMultiShapeUIView": (8, 4, 2023),
        "TriangleAnimation": (22, 1, 2023),
        "TimerView": (31, 1, 2023),
        "StarsBlinkView": (15, 7, 2023),
        "SpiralView": (22, 1, 2023),
        "RotatingDotsView": (14, 4, 2024),
        "RingsAnimationView": (3, 4, 2023),
        "RectRotationView": (29, 4, 2023),
        "GooglePhotosLogoAnim": (21, 4, 2023),
        "FireworksView": (9, 4, 2023),
        "DotsAnimationView": (29, 1, 2024),
        "DotsAnimPreview": (15, 4, 2023),
        "CirclesView": (4, 4, 2023),
        "CirclesRotationsView": (10, 9, 2023),
        "BatteryAnimation": (9, 6, 2023),
        "BarLoaderView": (25, 4, 2024)
    ]
    
    // Helper function to get date from static mapping
    private func extractDateFromFile(_ fileKey: String) -> (date: Date?, dateString: String, hasHeader: Bool) {
        guard let dateInfo = dateMap[fileKey] else {
            return (nil, "", false)
        }
        
        var components = DateComponents()
        components.day = dateInfo.day
        components.month = dateInfo.month
        components.year = dateInfo.year
        
        guard let date = Calendar.current.date(from: components) else {
            return (nil, "", false)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let dateStr = formatter.string(from: date)
        
        return (date, dateStr, true)
    }
    
    // Helper to wrap destination views with proper centering
    private func wrappedDestination<Content: View>(@ViewBuilder content: () -> Content) -> AnyView {
        AnyView(CenteredDetailView(content: content))
    }
    
    // File path mapping for date extraction
    private let filePathMap: [String: String] = [
        "ParallaxCarouselView": "legendary-Animo/Carousels/ParallaxCarouselView.swift",
        "UniqueLoadersGridView": "legendary-Animo/Animations/UniqueLoadersGridView.swift",
        "FullScreenDotFieldWave": "legendary-Animo/Animations/FullScreenDotFieldWave.swift",
        "HapticFeedback": "legendary-Animo/Animations/HapticFeedback.swift",
        "FullScreenDotFieldContinuous": "legendary-Animo/Animations/FullScreenDotFieldContinuous.swift",
        "Buttons": "legendary-Animo/Animations/Buttons.swift",
        "Circles3D": "legendary-Animo/Animations/Circles3D.swift",
        "CiclesTransView3D": "legendary-Animo/Animations/CiclesTransView3D.swift",
        "ChipsDrags": "legendary-Animo/Animations/ChipsDrags.swift",
        "FloatingView": "legendary-Animo/Animations/FloatingView.swift",
        "TriangleMultiShapeUIView": "legendary-Animo/Animations/TriangleMultiShapeUIView.swift",
        "TriangleAnimation": "legendary-Animo/Animations/TriangleAnimation.swift",
        "TimerView": "legendary-Animo/Animations/TimerView.swift",
        "StarsBlinkView": "legendary-Animo/Animations/StarsBlinkView.swift",
        "SpiralView": "legendary-Animo/Animations/SpiralView.swift",
        "RotatingDotsView": "legendary-Animo/Animations/RotatingDotsView.swift",
        "RingsAnimationView": "legendary-Animo/Animations/RingsAnimationView.swift",
        "RectRotationView": "legendary-Animo/Animations/RectRotationView.swift",
        "GooglePhotosLogoAnim": "legendary-Animo/Animations/GooglePhotosLogoAnim.swift",
        "FireworksView": "legendary-Animo/Animations/FireworksView.swift",
        "DotsAnimationView": "legendary-Animo/Animations/DotsAnimationView.swift",
        "DotsAnimPreview": "legendary-Animo/Animations/DotsAnimPreview.swift",
        "CirclesView": "legendary-Animo/Animations/CirclesView.swift",
        "CirclesRotationsView": "legendary-Animo/Animations/CirclesRotationsView.swift",
        "BatteryAnimation": "legendary-Animo/Animations/BatteryAnimation.swift",
        "BarLoaderView": "legendary-Animo/Animations/BarLoaderView.swift"
    ]
    
    // Helper to create DemoItem with automatic date extraction
    private func createDemoItem(
        row: RowView,
        destination: AnyView,
        fileKey: String? = nil
    ) -> DemoItem {
        var date: Date? = nil
        var dateString = ""
        var hasHeader = false
        
        if let key = fileKey {
            let extracted = extractDateFromFile(key)
            date = extracted.date
            dateString = extracted.dateString
            hasHeader = extracted.hasHeader
        }
        
        return DemoItem(
            row: row,
            destination: destination,
            date: date,
            dateString: dateString,
            hasDateHeader: hasHeader,
            filePath: fileKey != nil ? filePathMap[fileKey!] : nil
        )
    }
    
    // Latest first (add new items at the top)
    private var demos: [DemoItem] {
        let items: [DemoItem] = [
            // Latest animations
            createDemoItem(
                row: RowView(icon: "🌀", title: "Parallax Carousel", desc: "Drag the 3D ring of photos with parallax"),
                destination: wrappedDestination { ParallaxCarouselView() },
                fileKey: "ParallaxCarouselView"
            ),
            createDemoItem(
                row: RowView(icon: "🎛️", title: "Unique Loaders Grid", desc: "Multiple CSS-inspired loaders rebuilt in SwiftUI"),
                destination: wrappedDestination { UniqueLoadersGridView() },
                fileKey: "UniqueLoadersGridView"
            ),
            // Missing animations added
            createDemoItem(
                row: RowView(icon: "🪐", title: "Multi Orbit View", desc: "Interactive planet & satellite orbits"),
                destination: wrappedDestination {
                    MultiOrbitView(satellites: (0..<3).map { _ in Satellite.random() }, planetRadius: 1.5)
                }
            ),
            createDemoItem(
                row: RowView(icon: "🔘", title: "Micro Interaction Button", desc: "Loading states & morphing"),
                destination: wrappedDestination {
                    VStack(spacing: 24) {
                        MicroInteractionButton(icon: "applelogo", title: "Sign in with Apple") {
                            try? await Task.sleep(nanoseconds: 2_000_000_000)
                        }
                        MicroInteractionButton(icon: "heart.fill", title: "Like") {
                            try? await Task.sleep(nanoseconds: 1_500_000_000)
                        }
                    }
                    .padding()
                },
                fileKey: "Buttons"
            ),
            createDemoItem(
                row: RowView(icon: "⚫️", title: "Circles 3D", desc: "Animated 3D circles"),
                destination: wrappedDestination { Circles3D() },
                fileKey: "Circles3D"
            ),
            createDemoItem(
                row: RowView(icon: "💫", title: "Rotating Dots", desc: "Orbital rotating dots"),
                destination: wrappedDestination { RotatingDotsView() },
                fileKey: "RotatingDotsView"
            ),
            createDemoItem(
                row: RowView(icon: "⚡", title: "Flashing Button", desc: "Shimmer effect button"),
                destination: wrappedDestination { FlashingView() }
            ),
            createDemoItem(
                row: RowView(icon: "⚪️", title: "Dot Field Wave (Interactive)", desc: "Physics-based wave propagation"),
                destination: wrappedDestination {
                    FullScreenDotFieldWave()
                        .ignoresSafeArea()
                },
                fileKey: "FullScreenDotFieldWave"
            ),
            createDemoItem(
                row: RowView(icon: "🫧", title: "Floating View", desc: "Organic floating particles"),
                destination: wrappedDestination { FloatingView() },
                fileKey: "FloatingView"
            ),
            createDemoItem(
                row: RowView(icon: "⭕️", title: "3D Ring animation", desc: "Circles animation in Z axis"),
                destination: wrappedDestination { RingsAnimationView() },
                fileKey: "RingsAnimationView"
            ),
            createDemoItem(
                row: RowView(icon: "⦿", title: "Circles animation", desc: "Moving Circles animation in center with delay"),
                destination: wrappedDestination { CirclesView() },
                fileKey: "CirclesView"
            ),
            createDemoItem(
                row: RowView(icon: "⏳", title: "Countdown Timer for Fitness", desc: "A perfect fit in fitness app"),
                destination: wrappedDestination { TimerView() },
                fileKey: "TimerView"
            ),
            createDemoItem(
                row: RowView(icon: "🔺", title: "Triangle Animation", desc: "Multiple Gradient tringle shape scale animation"),
                destination: wrappedDestination { TriangleAnimationView() },
                fileKey: "TriangleAnimation"
            ),
            createDemoItem(
                row: RowView(icon: "𑗊", title: "MultiShapes 3D animation with rotation", desc: "Multiple shapes rotation"),
                destination: wrappedDestination { TriangleMultiShapeUIView() },
                fileKey: "TriangleMultiShapeUIView"
            ),
            createDemoItem(
                row: RowView(icon: "᠅", title: "Dots Circle Animation", desc: "Dashed circles smooth animation"),
                destination: wrappedDestination { DotsAnimPreview() },
                fileKey: "DotsAnimPreview"
            ),
            createDemoItem(
                row: RowView(icon: "🌇", title: "Google Photos Logo Animation", desc: "Logo using trim & offset"),
                destination: wrappedDestination { GooglePhotosLogoAnim() },
                fileKey: "GooglePhotosLogoAnim"
            ),
            createDemoItem(
                row: RowView(icon: "🔳", title: "Rectangle Rotation animation", desc: "Scale, offset & ease"),
                destination: wrappedDestination { RectRotationView() },
                fileKey: "RectRotationView"
            ),
            createDemoItem(
                row: RowView(icon: "🪫", title: "Battery Waves + Bubbles", desc: "Wave fill + bubbles"),
                destination: wrappedDestination { BatteryAnimation() },
                fileKey: "BatteryAnimation"
            ),
            createDemoItem(
                row: RowView(icon: "◎", title: "3D Circles animation", desc: "Time sequence z,y,z"),
                destination: wrappedDestination { CiclesTransViewOptimizeView() },
                fileKey: "CiclesTransView3D"
            ),
            createDemoItem(
                row: RowView(icon: "✨", title: "Blinking Stars Animation", desc: "Particle field"),
                destination: wrappedDestination { StarsBlinkView() },
                fileKey: "StarsBlinkView"
            ),
            createDemoItem(
                row: RowView(icon: "꩜", title: "Spiral Animation", desc: "Dynamic spiral"),
                destination: wrappedDestination { SpiralView() },
                fileKey: "SpiralView"
            ),
            createDemoItem(
                row: RowView(icon: "🔥", title: "Fireworks Animation", desc: "Explosive particles"),
                destination: wrappedDestination { FireworksView() },
                fileKey: "FireworksView"
            ),
            createDemoItem(
                row: RowView(icon: "✷", title: "Loader Animation v1", desc: "Magnetic hue rotation"),
                destination: wrappedDestination {
                    CirclesRotations(count: 5).frame(width: 100, height: 100)
                },
                fileKey: "CirclesRotationsView"
            ),
            createDemoItem(
                row: RowView(icon: "🧲", title: "Magnetic dots Animation", desc: "Hue rotation variations"),
                destination: wrappedDestination { DotsAnimationView() },
                fileKey: "DotsAnimationView"
            ),
            createDemoItem(
                row: RowView(icon: "⿲", title: "Bar Loader View", desc: "Indeterminate bar"),
                destination: wrappedDestination { BarLoaderView() },
                fileKey: "BarLoaderView"
            ),
            createDemoItem(
                row: RowView(icon: "🏷️", title: "Chips Drag & Drop", desc: "Falling chips with drag reordering"),
                destination: wrappedDestination { ChipsView() },
                fileKey: "ChipsDrags"
            ),
            // Additional chip animations from ChipsDrags.swift
            createDemoItem(
                row: RowView(icon: "🏷️", title: "Chips V2 (Optimized)", desc: "Drop-in chips with staggered animation"),
                destination: wrappedDestination { ChipsViewV2() },
                fileKey: "ChipsDrags"
            ),
            createDemoItem(
                row: RowView(icon: "🍃", title: "Falling Chips Physics", desc: "Realistic gravity & stacking"),
                destination: wrappedDestination { FallingChipsView() },
                fileKey: "ChipsDrags"
            )
        ]
        
        // Sort by date (latest first), then by title for items without dates
        return items.sorted { item1, item2 in
            if let date1 = item1.date, let date2 = item2.date {
                return date1 > date2 // Latest first
            } else if item1.date != nil {
                return true // Items with dates come first
            } else if item2.date != nil {
                return false
            } else {
                return item1.row.title < item2.row.title // Alphabetical for items without dates
            }
        }
    }
    
    private var sections: [(header: String, items: [(index: Int, date: String)])] {
        // Separate items without date headers from others
        var noHeaderItems: [(Int, String)] = []
        var headerItems: [(Int, String, Date)] = [] // Include Date for sorting
        
        for (idx, demo) in demos.enumerated() {
            if demo.hasDateHeader, let date = demo.date {
                headerItems.append((idx, demo.dateString, date))
            } else {
                noHeaderItems.append((idx, demo.dateString))
            }
        }
        
        // Sort header items by date (latest first)
        headerItems.sort { $0.2 > $1.2 }
        
        // Group items with date headers by month-year
        var grouped: [(String, [(Int, String)])] = []
        var headerToIndex: [String: Int] = [:]
        
        for item in headerItems {
            let header = monthHeader(from: item.2) // Use Date object
            if let existing = headerToIndex[header] {
                grouped[existing].1.append((item.0, item.1))
            } else {
                headerToIndex[header] = grouped.count
                grouped.append((header, [(item.0, item.1)]))
            }
        }
        
        // Add items without date headers as a separate section at the end
        if !noHeaderItems.isEmpty {
            grouped.append(("OTHER", noHeaderItems))
        }
        
        return grouped
    }

    private func monthHeader(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date).uppercased()
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
