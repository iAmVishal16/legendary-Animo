import SwiftUI

struct FlashingButtonView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            ZStack {
                // Button background
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .frame(width: 320, height: 50)
                    .shadow(radius: 5)
                
                // Button label
                Text("Sign in to Apple")
                    .fontWeight(.bold)
                    .foregroundStyle(.clear)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8), Color.clear]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 200)
                        .offset(x: animate ? 200 : -200)
                        .mask(
                            Text("Sign in to Apple")
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .frame(width: 200, height: 50)
                        )
                    )
                    .animation(Animation.easeInOut(duration: 4.5).repeatForever(autoreverses: false), value: animate)
            }
        }
        .onAppear {
            self.animate = true
        }
        .onTapGesture {
            self.animate = false // Stop animation on tap
        }
    }
}

struct FlashingView: View {
    var body: some View {
        VStack {
            FlashingButtonView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
    }
}

struct AnimatedGradient: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.8), Color.clear]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(width: 200, height: 50)
        .mask(RoundedRectangle(cornerRadius: 10))
        .offset(x: animate ? 200 : -200)
        .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false), value: animate)
    }
}

#Preview("FlashingView") {
    FlashingView()
}
