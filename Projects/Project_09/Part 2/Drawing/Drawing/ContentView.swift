//
//  ContentView.swift
//  Drawing
//
//  Created by Eric Schofield on 8/9/20.
//  Copyright © 2020 Eric Schofield. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var petalOffset: CGFloat = -20
    @State private var petalWidth: CGFloat = 100
    
    @State private var colorCycle = 0.0
    
    var body: some View {
//        Triangle()
//            .stroke(Color.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//            .frame(width: 300, height: 300)
        
//        Arc(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: true)
//            .stroke(Color.blue, lineWidth: 10)
//            .frame(width: 300, height: 300)
        
//        Circle()
//            .stroke(Color.blue, lineWidth: 40)
        
//        Circle()
//            .strokeBorder(Color.blue, lineWidth: 40)
        
//        Arc(startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
////            .stroke(Color.blue, lineWidth: 40)
//            .strokeBorder(Color.blue, lineWidth: 40)
        
//        VStack {
//            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
////                .stroke(Color.red, lineWidth: 1)
//                .fill(Color.red, style: FillStyle(eoFill: true))
//
//            Text("Offset: \(petalOffset, specifier: "%.1f")")
//            Slider(value: $petalOffset, in: -40...40)
//                .padding([.horizontal, .bottom])
//
//            Text("Width: \(petalWidth, specifier: "%.1f")")
//            Slider(value: $petalWidth, in: 0...100)
//                .padding(.horizontal)
//        }
        
        VStack {
            ColorCyclingCircle(amount: colorCycle)
                .frame(width: 300, height: 300)
            
            Slider(value: $colorCycle)
        }
    }
}

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: CGFloat(value))
//                    .strokeBorder(self.color(for: value, brightness: 1), lineWidth: 2)
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)
                    ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct Flower: Shape {
    // How much to move this petal away from the center
    var petalOffset: CGFloat = -20
    
    // How wide to make each petal
    var petalWidth: CGFloat = 100
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width / 2
        let height = rect.height / 2
        
        // The path that will hold all petals
        var path = Path()
        
        // Count from 0 up to pi * 2, moving up pi / 8 each time
        for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8) {
            // Rotate the petal by the current value of our loop
            let rotation = CGAffineTransform(rotationAngle: number)
            
            // Move the petal to be at the center of our view
            let position = rotation.concatenating(CGAffineTransform(translationX: width, y: height))
            
            // Create a path for this petal using our properties plus a fixed Y and height
            let originalPetal = Path(ellipseIn: CGRect(x: petalOffset, y: 0, width: petalWidth, height: width))
            
            // Apply our rotation/position transformation to the petal
            let rotatedPetal = originalPetal.applying(position)
            
            // Add it to our main path
            path.addPath(rotatedPetal)
        }
        
        // Now send the main path back
        return path
    }
}

struct Arc: InsettableShape {
    
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    
    var insetAmount: CGFloat = 0
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        
        return arc
    }
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        
        return path
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
