//
//  Pie.swift
//  MemoryGame
//
//  Created by 楢崎修二 on 2020/10/03.
//

import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockWise: Bool = false
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(CGFloat(startAngle.radians)),
            y: center.y + radius * sin(CGFloat(startAngle.radians))
        )
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockWise)
        p.addLine(to: center)
        return p
    }
}

struct PieModifier: AnimatableModifier {
    @State private var animatedTimeoutRemaining: Double = 0
    
    // MARK: - animation settings
    var isFaceUp: Bool = true {
        didSet {
            if isFaceUp {
                startTimer()
            } else {
                stopTimer()
            }
        }
    }
    var timeout: Int
    @Binding var flip: Bool
    var timeoutInterval: TimeInterval {
        TimeInterval(timeout)
    }
    var faceUpTime: TimeInterval {
        if let lastFaceUpDate = self.lastFaceUpDate {
            return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
        } else {
            return pastFaceUpTime
        }
    }
    var lastFaceUpDate: Date?
    var pastFaceUpTime: TimeInterval = 0
    var timeoutRemaining: TimeInterval {
        max(0, timeoutInterval - faceUpTime)
    }
    var timeoutRemainingRatio: Double {
        (timeoutInterval > 0 && timeoutRemaining > 0) ? timeoutRemaining / timeoutInterval : 0
    }
    
    var isConsumingBonusTime: Bool {
        isFaceUp && timeoutRemaining > 0
    }
    private mutating func startTimer() {
        /* if isConsumingBonusTime, lastFaceUpDate == nil {
            lastFaceUpDate = Date()
        } */
        lastFaceUpDate = Date()
    }
    private mutating func stopTimer() {
        pastFaceUpTime = faceUpTime
        self.lastFaceUpDate = nil
    }
    private mutating func resetTimer() {
        pastFaceUpTime = 0
        self.lastFaceUpDate = nil
    }
    private func startTimeoutAnimation() {
        animatedTimeoutRemaining = self.timeoutRemainingRatio
        withAnimation(.linear(duration: self.timeoutRemaining)) {
            animatedTimeoutRemaining = 0
        }
    }
    func body(content: Content) -> some View {
        ZStack {
            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedTimeoutRemaining*360-90), clockWise: true )
                .onAppear {
                    self.startTimeoutAnimation()
                }
                .onChange(of: flip, perform: { value in
                    self.startTimeoutAnimation()
                })
                .padding()
                .foregroundColor(.yellow)
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            content
        }
        .transition(AnyTransition.scale)
    }
}

extension View {
    func withPie(timeout: Int, flag: Binding<Bool>) -> some View {
        self.modifier(PieModifier(timeout: timeout, flip: flag))
    }
}

struct Pie_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Text("sample")
                .font(.title)
        }
        .withPie(timeout: 10, flag: .constant(true))
    }
}
