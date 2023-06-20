//
//  BatteryAnimation.swift
//  ShapeAnimation
//
//  Created by Vishal Paliwal on 09/06/23.
//

import SwiftUI

struct BatteryAnimation_Previews: PreviewProvider {
    static var previews: some View {
        BatteryAnimation()
            .preferredColorScheme(.dark)
    }
}

struct BatteryAnimation: View {
    
    @State var animate = false
    let screen = UIScreen.main.bounds

    let color1 = Color("ColorPinkLight")
    let color2 = Color("ColorBlueLight")
    
    @State private var percent = 0.0
    let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    @State private var waveOffset = Angle(degrees: 0)
    @State var replay: Bool = false

    
    var body: some View {
        
        let colorStops: [Gradient.Stop] = [
            .init(color: color1, location: 0.0),
            .init(color: color2, location: 0.6),
        ]
        
        ZStack {
            Color("ColorBG")
                .edgesIgnoringSafeArea(.all)
            ZStack {
                ZStack {
                    
                    Color("ColorBG")
                        .edgesIgnoringSafeArea(.all)
                    
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(lineWidth: 1.0)
                        .foregroundColor(.clear)
                        .frame(width: 180, height: 240, alignment: .bottom)
                        .opacity(0.8)
                        .overlay(
                            GeometryReader { geo in
                                ZStack {
                                    Wave(waveHeight: 30, phase: percent)
                                        .fill(
                                            LinearGradient(stops: colorStops, startPoint: .top, endPoint: .bottom)
                                        )
                                        .foregroundColor(.red)
                                        .opacity(1.0)
                                    }
                                
                                BubbleEffectView(replay: $replay)
                            }
                                .frame(height: 220, alignment: .center)
                                .offset(y: 100.0)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .offset(y: 30.0)
                    
                    
                    
                    
                }
            }
            ZStack {
                VStack (spacing: -8) {
                    Capsule()
                        .trim(from: 0.0, to: 0.5)
                        .frame(width: 65, height: 30, alignment: .center)
                        .rotationEffect(.degrees(180))
                    
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(lineWidth: 1.0)
                        .frame(width: 200, height: 300, alignment: .center)
                        .opacity(0.8)
                        .overlay(alignment: .topTrailing) {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(lineWidth: 1.0)
                                .frame(width: 1, height: 30, alignment: .center)
                                .opacity(0.8)
                                .offset(x: -10.0, y: 40)
                        }
                        .overlay(alignment: .bottomLeading) {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Material.ultraThinMaterial.opacity(0.6))
                                .frame(width: 20, height: 80, alignment: .center)
                                .opacity(0.8)
                                .offset(x: 20.0, y: -40)
                        }
                    
                }
            }
        }
//        .onAppear {
//            animate.toggle()
//        }
        .onReceive(timer) { input in
            withAnimation {
            self.percent += 35
//            self.waveOffset = .degrees(self.percent)
                replay.toggle()
            }

        }
    }
    }

struct Wave: Shape {
    
    var waveHeight: CGFloat
    var phase: CGFloat
    
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
        
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Bottom Left
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        
        for x in stride(from: 0, through: rect.width, by: 1) {
            //wavelength
            let relativeX: CGFloat = x / 50
            let angle = Angle(degrees: phase)
            let sine = CGFloat(sin(relativeX + CGFloat(angle.radians)))
            let y = waveHeight * sine
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        // Top Right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        // Bottom Right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        return path
    }
}

struct BubbleEffectView: View {
    @StateObject var viewModel: BubbleEffectViewModel = BubbleEffectViewModel()
    @Binding var replay: Bool
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                //Show bubble views for each bubble
                ForEach(viewModel.bubbles){bubble in
                    BubbleView(bubble: bubble)
                }
            }.onChange(of: replay, perform: { _ in
                viewModel.addBubbles(frameSize: geo.size)
            })
            
            .onAppear(){
                //Set the initial position from frame size
                viewModel.viewBottom = geo.size.height
                viewModel.addBubbles(frameSize: geo.size)
            }
        }
    }
}

class BubbleEffectViewModel: ObservableObject{
    @Published var viewBottom: CGFloat = CGFloat.zero
    @Published var bubbles: [BubbleViewModel] = []
    private var timer: Timer?
    private var timerCount: Int = 0
    @Published var bubbleCount: Int = 50
    
    func addBubbles(frameSize: CGSize){
        let lifetime: TimeInterval = 2
        //Start timer
        timerCount = 0
        if timer != nil{
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            let bubble = BubbleViewModel(height: 10, width: 10, x: frameSize.width/2, y: self.viewBottom, color: .white, lifetime: lifetime)
            //Add to array
            self.bubbles.append(bubble)
            //Get rid if the bubble at the end of its lifetime
            Timer.scheduledTimer(withTimeInterval: bubble.lifetime, repeats: false, block: {_ in
                self.bubbles.removeAll(where: {
                    $0.id == bubble.id
                })
            })
            if self.timerCount >= self.bubbleCount {
                //Stop when the bubbles will get cut off by screen
                timer.invalidate()
                self.timer = nil
            }else{
                self.timerCount += 1
            }
        }
    }
}

struct BubbleView: View {
    //If you want to change the bubble's variables you need to observe it
    @ObservedObject var bubble: BubbleViewModel
    @State var opacity: Double = 0
    var body: some View {
        Circle()
            .foregroundColor(bubble.color)
            .opacity(opacity)
            .frame(width: bubble.width, height: bubble.height)
            .position(x: bubble.x, y: bubble.y)
            .onAppear {
                
                withAnimation(.linear(duration: bubble.lifetime)){
                    //Go up
                    self.bubble.y = -bubble.height
                    //Go sideways
                    self.bubble.x += bubble.xFinalValue()
                    //Change size
                    let width = bubble.yFinalValue()
                    self.bubble.width = width
                    self.bubble.height = width
                }
                //Change the opacity faded to full to faded
                //It is separate because it is half the duration
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.linear(duration: bubble.lifetime/2).repeatForever()) {
                        self.opacity = 1
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(Animation.linear(duration: bubble.lifetime/4).repeatForever()) {
                        //Go sideways
                        //bubble.x += bubble.xFinalValue()
                    }
                }
            }
    }
}

class BubbleViewModel: Identifiable, ObservableObject{
    let id: UUID = UUID()
    @Published var x: CGFloat
    @Published var y: CGFloat
    @Published var color: Color
    @Published var width: CGFloat
    @Published var height: CGFloat
    @Published var lifetime: TimeInterval = 0
    init(height: CGFloat, width: CGFloat, x: CGFloat, y: CGFloat, color: Color, lifetime: TimeInterval){
        self.height = height
        self.width = width
        self.color = color
        self.x = x
        self.y = y
        self.lifetime = lifetime
    }
    func xFinalValue() -> CGFloat {
        return CGFloat.random(in:-width*CGFloat(lifetime*2.5)...width*CGFloat(lifetime*2.5))
    }
    func yFinalValue() -> CGFloat {
        return CGFloat.random(in:0...width*CGFloat(lifetime*2.5))
    }
    
}
