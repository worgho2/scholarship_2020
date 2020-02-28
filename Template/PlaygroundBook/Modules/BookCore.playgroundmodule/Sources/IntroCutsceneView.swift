//
//  CutsceneView.swift
//  BookCore
//
//  Created by otavio on 27/02/20.
//

import SwiftUI
import PlaygroundSupport

struct WedgeShape: Shape {
    let startAngle: Double
    let angleSize: Double
    
    func path(in rect: CGRect) -> Path {
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
    
    public enum RuleMapType {
        case wrong
        case correct
    }
    
    @State private var colors: [Color] = [.clear, .green, .blue, .orange, .red]
    @State private var shapeColorState: [Int] = [0,0,0,0]
    
    @State public var ruleTitle: String = "Title"
    @State public var mapType: RuleMapType = .wrong
    
    public var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    Spacer()
                    Text("\(self.ruleTitle)")
                        .lineLimit(4)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    Spacer(minLength: 25)
                    
                    ZStack(alignment: .center) {
                        ForEach(0...2, id: \.self) { index in
                            ZStack(alignment: .center) {
                                WedgeShape(startAngle: 120 * Double(index), angleSize: 120)
                                    .foregroundColor(self.colors[self.shapeColorState[index]])
                                
                                WedgeShape(startAngle: 120 * Double(index), angleSize: 120)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        Group {
                            Circle()
                                .foregroundColor(self.colors[self.shapeColorState[3]])
                            
                            Circle().stroke(lineWidth: 2).foregroundColor(.primary)
                        }.frame(width: geometry.size.width * 1/3, height: geometry.size.height * 1/3, alignment: .center)
                        
                        ZStack() {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: geometry.size.width/5, height: geometry.size.width/5, alignment: .bottomTrailing)
                        }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottomTrailing)
                        
                    }.padding(.horizontal)
                    
                    
                }
            }
        }.onAppear() {
            self.shapeColorState = (self.mapType == .correct) ? [1,2,3,4] : [0,0,4,4]
        }
        
    }
}

public struct RulesView: View {
    
    public var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    
                    Text("Rules").font(.body)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 35, style: .circular)
                            .stroke(lineWidth: 5)
                            .foregroundColor(.primary)
                        
                        VStack {
                            Spacer(minLength: 25)
                            MapRuleView(ruleTitle: "Neighboring spaces cannot have same color", mapType: .wrong)
                                .scaledToFit()
                                .padding(.horizontal, 50)
                            
                            Spacer(minLength: 25)
                            MapRuleView(ruleTitle: "Neighboring spaces cannot have same color", mapType: .correct)
                                .scaledToFit()
                                .padding(.horizontal, 50)
                            
                            Spacer(minLength: 25)
                        }
                        
                    }
                    
                }
                
            }
        }
    }
    
}

public struct ContentView: View {
    
    public var body: some View {
        ZStack {
            Color.primary.colorInvert()
            
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    Spacer()
                    Text("Paint de map below")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        RulesView()
                        RulesView()
                        RulesView()
                        RulesView()
                    }
                    
                }
            }
        }
    }
    
    public init() { }
}
