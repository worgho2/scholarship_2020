//
//  CutsceneView.swift
//  BookCore
//
//  Created by otavio on 27/02/20.
//

import SwiftUI
import PlaygroundSupport

public struct ContentView: View {
    @State public var canGoForward: Bool = false
    
    @State public var hintOpacity: Double = 0
    public var repeatingAnimation: Animation {
        Animation
            .easeIn(duration: 1)
            .repeatForever()
    }
    
    public var hintAnimation: Animation {
        Animation
            .easeIn(duration: 1)
            .repeatCount(3)
    }
    
    public init() {
        
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                VStack(alignment: .center, spacing: 50) {
                    
                    if self.canGoForward {
                        Spacer()
                        
                        Text("Congratulation! on this example four colors were needed. But is there a minimum number to color any map? Find out on the next page!")
                            .font(.largeTitle)
                            .bold()
                            .lineSpacing(15)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 60)
                            .transition(.opacity)
                        
                        Text("Tap the '>' button at the top of the page to continue")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .opacity(self.hintOpacity)
                            .onAppear() {
                                self.hintOpacity = 0
                                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { t in
                                    withAnimation(self.repeatingAnimation) { self.hintOpacity = 1 }
                                }
                                
                        }
                        
                        Spacer()
                    }
                    
                    if !self.canGoForward {
                        Spacer(minLength: 25)
                        
                        Text("Try to color the map below using as few colors as possible following the rule: neighboring spaces cannot have the same color")
                            .font(.largeTitle)
                            .bold()
                            .lineSpacing(15)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 60)
                            .transition(.opacity)
                        
                        Text("Tap the blank space to change the color")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .opacity(self.hintOpacity)
                            .onAppear() {
                                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { t in
                                    withAnimation(self.hintAnimation) { self.hintOpacity = 1 }
                                    
                                    Timer.scheduledTimer(withTimeInterval: 6, repeats: false) {_ in
                                        withAnimation(.default) { self.hintOpacity = 0 }
                                    }
                                }
                        }
                        
                        
                        IntroMapView(canGoForward: self.$canGoForward)
                            .disabled(self.canGoForward)
                            .scaledToFit()
                            .transition(.asymmetric(insertion: .scale, removal: .opacity))
                        
                        Spacer()
                    }
                    
                }
            }
        }
    }
}

public struct IntroMapView: View {
    public let colors: [Color] = [.white, .green, .blue, .orange, .red]
    
    @State public var shapeColorState: [Int] = [1,2,1,2,3,4,3,4,0]
    @State public var mapIsCorrect: Bool = false {
        didSet {
            if mapIsCorrect {
                self.performMapCompletion()
            }
        }
    }
    
    @Binding public var canGoForward: Bool
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 45) {
                ZStack(alignment: .center) {
                    ForEach(0...3, id: \.self) { index in
                        ZStack(alignment: .center) {
                            WedgeShape(startAngle: 90 * Double(index))
                                .foregroundColor(self.colors[self.shapeColorState[index]])
                                .onTapGesture {
                                    self.shapeColorState[index] = (self.shapeColorState[index] + 1) % self.colors.count
                                    self.mapIsCorrect = self.checkMap()
                            }
                            
                            WedgeShape(startAngle: 90 * Double(index))
                                .stroke(lineWidth: 2)
                                .foregroundColor(.black)
                        }.frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                    }
                    
                    ForEach(4...7, id: \.self) { index in
                        ZStack(alignment: .center) {
                            WedgeShape(startAngle: Double(45) + (90 * Double(index)))
                                .foregroundColor(self.colors[self.shapeColorState[index]])
                                .onTapGesture {
                                    self.shapeColorState[index] = (self.shapeColorState[index] + 1) % self.colors.count
                                    self.mapIsCorrect = self.checkMap()
                            }
                            
                            WedgeShape(startAngle: Double(45) + (90 * Double(index)))
                                .stroke(lineWidth: 2)
                                .foregroundColor(.black)
                            
                        }.frame(width: geometry.size.width * 2/3, height: geometry.size.width * 2/3, alignment: .center)
                    }
                    
                    Group {
                        Circle()
                            .foregroundColor(self.colors[self.shapeColorState[8]])
                            .onTapGesture {
                                self.shapeColorState[8] = (self.shapeColorState[8] + 1) % self.colors.count
                                self.mapIsCorrect = self.checkMap()
                        }
                        
                        Circle().stroke(lineWidth: 2).foregroundColor(.black)
                    }.frame(width: geometry.size.width * 1/3, height: geometry.size.width * 1/3, alignment: .center)
                    
                }.animation(.interactiveSpring())
                ZStack(alignment: .center) {
                    Capsule()
                        .frame(width: 150, height: 35, alignment: .center)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        for i in 0..<self.shapeColorState.count {
                            self.shapeColorState[i] = 0
                        }
                    }, label: {
                        Text("Reset")
                    })
                        .foregroundColor(.primary).colorInvert()
                }
                
            }
            
        }.edgesIgnoringSafeArea(.all)
    }
    
    public func checkMap() -> Bool {
        
        if self.shapeColorState.contains(0) {
            print(false)
            return false
        }
        
        if [1,3,4,7].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[0]) ||
            [2,4,5].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[1]) ||
            [3,5,6].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[2]) ||
            [6,7].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[3]) ||
            [5,7,8].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[4]) ||
            [6,8].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[5]) ||
            [7,8].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[6]) ||
            [8].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[7]) {
            print(false)
            return false
        } else {
            print(true)
            return true
        }
        
    }
    
    public func performMapCompletion() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { t in
            withAnimation(.linear(duration: 0.5)) { self.canGoForward = true }
            t.invalidate()
        }
    }
    
    
    
}

public struct WedgeShape: Shape {
    public let startAngle: Double
    
    public func path(in rect: CGRect) -> Path {
        var p = Path()
        let center: CGPoint =  CGPoint(x: rect.size.width/2, y: rect.size.width/2)
        
        p.addArc(center: center,
                 radius: rect.size.width/2,
                 startAngle: Angle(degrees: self.startAngle),
                 endAngle: Angle(degrees: self.startAngle + 90),
                 clockwise: false
        )
        p.addLine(to: center)
        p.closeSubpath()
        
        return p
    }
}
