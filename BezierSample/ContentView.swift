//
//  ContentView.swift
//  BezierSample
//
//  Created by yogox on 2022/04/11.
//

import SwiftUI

enum Points {
    case p0
    case p1
    case c1
    case c2
}

struct BezierCurve: Shape {
    let p0: CGPoint
    let p1: CGPoint
    let c1: CGPoint
    let c2: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: p0)
        path.addCurve(to: p1, control1: c1, control2: c2)
        return path
    }
}

struct ContentView: View {
    @State var p0:CGPoint = .zero
    @State var p1:CGPoint = .zero
    @State var c1:CGPoint = .zero
    @State var c2:CGPoint = .zero
    @State var select: Points = .p0
    
    let radius: CGFloat = 5
    let initialDistance: CGFloat = 150
    
    let buttonWidth: CGFloat = 75
    let buttonHeight: CGFloat = 30
    let buttonPadding: CGFloat = 5
    
    var body: some View {
        return  GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                ZStack(alignment: .topLeading) {
                    BezierCurve(p0: p0, p1: p1, c1: c1, c2: c2)
                        .stroke()
                    dotByPoint(p0, .p0, .red)
                    dotByPoint(p1, .p1, .blue)
                    dotByPoint(c1, .c1, .green)
                    dotByPoint(c2, .c2, .purple)
                }
                .ignoresSafeArea()
                .onAppear() {
                    p0 = CGPoint(x: 0 + radius, y: height/2)
                    p1 = CGPoint(x: width - radius, y: height/2)
                    c1 = CGPoint(x: width/2, y: height/2 - initialDistance)
                    c2 = CGPoint(x: width/2, y: height/2 + initialDistance)
                }
                .onTouch(perform: updateLocation)
                
                HStack() {
                    selectButton("p0", .p0, .red)
                    selectButton("p1", .p1, .blue)
                    selectButton("c1", .c1, .green)
                    selectButton("c2", .c2, .purple)
                }
                .offset(x: 0, y: -buttonHeight)
                .frame(width: width, height: height, alignment: .bottom)
                .foregroundColor(.primary)
            }
        }
    }
    
    func dotByPoint(_ p: CGPoint, _ select: Points, _ color: Color) -> some View  {
        Circle()
            .fill(color)
            .frame(width: radius * 2, height: radius * 2)
            .offset(x: p.x - radius, y: p.y - radius)
            .opacity(self.select == select ? 1.0 : 0.5)
    }
    
    func selectButton(_ name: String, _ select: Points, _ color: Color)  -> some View  {
        Button(action: {
            self.select = select
        }) {
            Text(name)
                .frame(width: buttonWidth, height: buttonHeight)
                .background(color)
                .opacity(self.select == select ? 1.0 : 0.5)
        }
    }
    
    func updateLocation(_ location: CGPoint) {
        switch select {
        case .p0:
            p0 = location
        case .p1:
            p1 = location
        case .c1:
            c1 = location
        case .c2:
            c2 = location
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

