//
//  GooglePhotosLogoAnim.swift
//  Banners
//
//  Created by Vishal Paliwal on 21/04/23.
//

import SwiftUI

struct GooglePhotosLogoAnim_Previews: PreviewProvider {
    static var previews: some View {
        GooglePhotosLogoAnim()
            .preferredColorScheme(.dark)
    }
}

struct GooglePhotosLogoAnim: View {
    @State private var animate = false

    var body: some View {
        VStack {

            ZStack {

                RoundedRectangle(cornerRadius: 36)
                    .frame(width: animate ? 150 : 0, height: animate ? 150 : 0)
                    .animation(Animation.easeInOut(duration: 2.5).delay(5.5), value: animate)

                ZStack {
                    RoundedRectangle(cornerRadius: 36)
                        .trim(from: 0, to: animate ? 1 : 0.0)
                        .stroke(lineWidth: 4)
                        .frame(width: 150, height: 150)
                        .animation(Animation.easeInOut(duration: 2.5), value: animate)

                    HStack (spacing: 0) {
                        Circle()
                            .trim(from: 0, to: 0.5)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.red)
                            .rotationEffect(.degrees(180))

                        Circle()
                            .trim(from: 0, to: 0.5)
                            .frame(width: 50, height: 50)
                            .offset(x: animate ? 0 :-50)
                            .foregroundColor(.green)
                            .animation(Animation.easeInOut(duration: 0.5).delay(2.5), value: animate)

                    }
                    .rotationEffect(.degrees( animate ? 90 : 180))
                    .animation(Animation.easeInOut(duration: 1.5).delay(3.5), value: animate)

                    HStack (spacing: 0) {
                        Circle()
                            .trim(from: 0, to: 0.5)
                            .frame(width: 50, height: 50)
                            .foregroundColor(animate ? .yellow : .white)
                            .rotationEffect(.degrees(180))

                        Circle()
                            .trim(from: 0, to: 0.5)
                            .frame(width: 50, height: 50)
                            .foregroundColor(animate ? .blue : .white)
                            .offset(x: animate ? 0 : -50)
                            .animation(Animation.easeInOut(duration: 0.5).delay(2.5), value: animate)

                    }
                    .rotationEffect(.degrees(animate ? 0 : 180))
                    .animation(Animation.easeInOut(duration: 1.5).delay(3.5), value: animate)

                }
                .opacity(animate ? 1: 0)
                .animation(Animation.easeInOut(duration: 0.5).delay(0.5), value: animate)
            }

            Text("Google Photos")
                .font(.title)
                .fontWeight(.light)
                .padding(.top, 8)
                .opacity(animate ? 1: 0)
                .scaleEffect(animate ? 1 : 2.5)
                .animation(Animation.easeInOut(duration: 2.5).delay(5.5), value: animate)
        }
        .onAppear {
            animate.toggle()
        }
    }
}
