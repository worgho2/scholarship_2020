//
//  CutsceneView.swift
//  BookCore
//
//  Created by otavio on 27/02/20.
//

import PlaygroundSupport
import SwiftUI

public struct WedgeShape: Shape {
    let startAngle: Double
    let angleSize: Double
    
    public func path(in rect: CGRect) -> Path {
        var p = Path()
        let center: CGPoint =  CGPoint(x: rect.size.width/2, y: rect.size.width/2)
        
        p.addArc(center: center,
                 radius: rect.size.width/2,
                 startAngle: Angle(degrees: self.startAngle),
                 endAngle: Angle(degrees: self.startAngle + self.angleSize),
                 clockwise: false
        )
        p.addLine(to: center)
        p.closeSubpath()
        return p
    }
}

public struct MapRuleView: View {
    
    public enum MapRuleType {
        case wrong
        case correct
    }
    
    @State private var colors: [Color] = [Color(#colorLiteral(red: 0.1137254902, green: 0.1137254902, blue: 0.1137254902, alpha: 1)), .green, .blue, .orange, .red]
    @State private var shapeColorState: [Int] = [0,0,0,0]
    
    @State public var ruleTitle: String = "Title"
    @State public var mapType: MapRuleType = .wrong
    
    public var body: some View {
        ZStack {
            VStack(alignment: .center) {
                
                Text("\(self.ruleTitle)")
                    .lineLimit(4)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                GeometryReader { geometry in
                    ZStack {
                        ForEach(0...2, id: \.self) { index in
                            Group {
                                WedgeShape(startAngle: 120 * Double(index), angleSize: 120)
                                    .foregroundColor(self.colors[self.shapeColorState[index]])
                                
                                WedgeShape(startAngle: 120 * Double(index), angleSize: 120)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.primary)
                                
                            }
                            .scaledToFit()
                            .position(x: geometry.size.width/2, y: geometry.size.height/2)
                        }
                        
                        Group {
                            Circle()
                                .scale(0.33333)
                                .foregroundColor(self.colors[self.shapeColorState[3]])
                            
                            Circle()
                                .scale(0.33333)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.primary)
                            
                        }
                        .scaledToFit()
                        .position(x: geometry.size.width/2, y: geometry.size.height/2)
                        
                        Rectangle()
                            .path(in: CGRect(x: geometry.size.width/2  + geometry.size.height * 0.3,
                                             y: geometry.size.height/2 + geometry.size.height * 0.3,
                                             width: geometry.size.height * 0.2,
                                             height: geometry.size.height * 0.2
                            ))
                            .fill(Color.blue)
                    }
                }
            }
        }.onAppear() {
            self.shapeColorState = (self.mapType == .correct) ? [4,3,2,1] : [0,4,0,4]
        }
    }
}

public struct RulesView: View {
    
    public var body: some View {
        ZStack {
            VStack {
                Text("Rules").font(.title)
                
                GeometryReader { geometry in
                    ZStack {
                        RoundedRectangle(cornerRadius: 35, style: .circular)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.primary)
                        
                        VStack(spacing: geometry.size.height * 0.05) {
                            
                            MapRuleView(ruleTitle: "Neighboring spaces cannot have same color", mapType: .wrong)
                                .padding()
                            
                            MapRuleView(ruleTitle: "All spaces need to be painted", mapType: .correct)
                                .padding()
                            
                        }
                        
                    }
                }
                
            }
        }
        
    }
}

public struct MapCommandView: View {
    
    public enum MapCommandType {
        case tap
        case longPress
    }
    
    @State private var colors: [Color] = [Color(#colorLiteral(red: 0.1137254902, green: 0.1137254902, blue: 0.1137254902, alpha: 1)), .green, .blue, .orange, .red]
    @State private var shapeColorState: [Int] = [0,0,0,0]
    
    @State public var ruleTitle: String = "Title"
    @State public var commandType: MapCommandType = .tap
    
    public var body: some View {
        ZStack {
            VStack(alignment: .center) {
                
                Text("\(self.ruleTitle)")
                    .lineLimit(4)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                GeometryReader { geometry in
                    ZStack {
                        ForEach(0...2, id: \.self) { index in
                            Group {
                                WedgeShape(startAngle: 120 * Double(index), angleSize: 120)
                                    .foregroundColor(self.colors[self.shapeColorState[index]])
                                
                                WedgeShape(startAngle: 120 * Double(index), angleSize: 120)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.primary)
                                
                            }
                            .scaledToFit()
                            .position(x: geometry.size.width/2, y: geometry.size.height/2)
                        }
                        
                        Group {
                            Circle()
                                .scale(0.33333)
                                .foregroundColor(self.colors[self.shapeColorState[3]])
                            
                            Circle()
                                .scale(0.33333)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.primary)
                            
                        }
                        .scaledToFit()
                        .position(x: geometry.size.width/2, y: geometry.size.height/2)
                        
                        Rectangle()
                            .path(in: CGRect(x: geometry.size.width/2 + geometry.size.height * 0.15,
                                             y: geometry.size.height/2 - geometry.size.height * 0.2 - geometry.size.height * 0.15,
                                             width: geometry.size.height * 0.2,
                                             height: geometry.size.height * 0.2
                            ))
                            .fill(Color.blue)
                    }
                }
            }
        }.onAppear() {
            self.shapeColorState = (self.commandType == .tap) ? [0,0,1,0] : [1,2,0,3]
        }
    }
}

public struct CommandsView: View {
    
    public var body: some View {
        ZStack {
            VStack {
                Text("Commands").font(.title)
                
                GeometryReader { geometry in
                    ZStack {
                        RoundedRectangle(cornerRadius: 35, style: .circular)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.primary)
                        
                        VStack(spacing: geometry.size.height * 0.05) {
                            
                            MapCommandView(ruleTitle: "Tap any space to change it's color", commandType: .tap)
                                .padding()
                            
                            MapCommandView(ruleTitle: "Long press any space to clear it's color", commandType: .longPress)
                                .padding()
                            
                        }
                        
                    }
                }
                
            }
        }
        
    }
}

public struct MapView: View {
    @State private var colors: [Color] = [Color(#colorLiteral(red: 0.1137254902, green: 0.1137254902, blue: 0.1137254902, alpha: 1)), .green, .blue, .orange, .red]
    @State private var shapeColorState: [Int] = [0,0,0,0,0,0,0,0,0]
    @State private var isMapCorrect: Bool = false
    
    public var body: some View {
        ZStack {
            VStack {
                
                GeometryReader { geometry in
                    ZStack {
                        
                        ForEach(0...3, id: \.self) { index in
                            Group {
                                WedgeShape(startAngle: 90 * Double(index), angleSize: 90)
                                    .foregroundColor(self.colors[self.shapeColorState[index]])
                                    .onTapGesture {
                                        self.shapeColorState[index] = (self.shapeColorState[index] + 1) % self.colors.count
                                        self.checkMap()
                                    }
                                    .onLongPressGesture {
                                        self.shapeColorState[index] = 0
                                    }
                                
                                WedgeShape(startAngle: 90 * Double(index), angleSize: 90)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.primary)
                                
                            }
                            .scaledToFit()
                            .position(x: geometry.size.width/2, y: geometry.size.height/2)
                        }
                        
                        ForEach(4...7, id: \.self) { index in
                            Group {
                                WedgeShape(startAngle: Double(45) + (90 * Double(index)), angleSize: 90)
                                    .scale(0.666)
                                    .foregroundColor(self.colors[self.shapeColorState[index]])
                                    .onTapGesture {
                                        self.shapeColorState[index] = (self.shapeColorState[index] + 1) % self.colors.count
                                        self.checkMap()
                                    }
                                    .onLongPressGesture {
                                        self.shapeColorState[index] = 0
                                    }

                                WedgeShape(startAngle: Double(45) + (90 * Double(index)), angleSize: 90)
                                    .scale(0.666)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.primary)

                            }
                            .scaledToFit()
                            .position(x: geometry.size.width/2, y: geometry.size.height/2)
                        }
                        
                        Group {
                            Circle()
                                .scale(0.33333)
                                .foregroundColor(self.colors[self.shapeColorState[8]])
                                .onTapGesture {
                                    self.shapeColorState[8] = (self.shapeColorState[8] + 1) % self.colors.count
                                    self.checkMap()
                                }
                                .onLongPressGesture {
                                    self.shapeColorState[8] = 0
                                }
                            
                            Circle()
                                .scale(0.33333)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.primary)
                            
                        }
                        .scaledToFit()
                        .position(x: geometry.size.width/2, y: geometry.size.height/2)
 
                    }
                }.layoutPriority(1).padding()
                
                Button(action: {
                    if self.isMapCorrect {
                        PlaygroundPage.current.navigateTo(page: .next)
                    } else {
                        self.onReset()
                    }
                }, label: {
                    Text(self.isMapCorrect ? "Next" : "Reset")
                        .bold()
                        .font(.title)
                        .padding(.horizontal, 80)
                        .padding(.vertical, 10)
                        .background(self.isMapCorrect ? Color.green : Color.orange)
                        .cornerRadius(40)
                        .foregroundColor(.primary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.primary, lineWidth: 5)
                        )
                    
                })
                    
            }
        }
    }
    
    private func checkMap() {
        if self.shapeColorState.contains(0) {
            self.isMapCorrect = false
            return
        }
        
        self.isMapCorrect = !( [1,3,4,7].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[0]) ||
            [2,4,5].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[1]) ||
            [3,5,6].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[2]) ||
            [6,7].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[3]) ||
            [5,7,8].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[4]) ||
            [6,8].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[5]) ||
            [7,8].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[6]) ||
            [8].map({ self.shapeColorState[$0] }).contains(self.shapeColorState[7]) )
    }
    
    private func onReset() {
        self.shapeColorState = self.shapeColorState.map({$0 * 0})
    }
}

public struct ContentView: View {
    
    public var body: some View {
        ZStack {
            Color.primary.colorInvert()
            
            VStack(spacing: 25) {
                
                Spacer(minLength: 10)
                
                Text("Paint de map below")
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                GeometryReader { geometry in
                    HStack(spacing: 10) {
                        Spacer(minLength: 25)
                        RulesView()
                        MapView().frame(width: geometry.size.width/2)
                        CommandsView()
                        Spacer(minLength: 25)
                    }
                    
                }
                
                Spacer(minLength: 40)
            }
            
        }
    }
    
    public init() { }
}
