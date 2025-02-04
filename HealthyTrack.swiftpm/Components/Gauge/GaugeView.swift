//
//  GaugeView.swift
//  IntervalTrack
//
//  Created by Yann Berton on 28.01.25.
//

import SwiftUI

@available(iOS 17.0, *)
struct GaugeView: View {
    @Binding var timeSince: Double
    
    var currentPhase: GaugeSegment {
        let normalizedTime = min(timeSince, 16.0)
        var cumulativeTime = 0.0
        
        for segment in descriptor.segments {
            let startTime = cumulativeTime
            let endTime = cumulativeTime + Double(segment.lengthInHours)
            
            if normalizedTime >= startTime && normalizedTime < endTime {
                return segment
            }
            
            cumulativeTime = endTime
        }
        
        return descriptor.segments.last! // Default to the last segment if timeSince exceeds all ranges
    }
    
    @State var showInfo: Bool = false
    @State var selectedPhase: GaugeSegment?
    
    @State var descriptor = GaugeDescriptor(
        maxNumber: 16,
        segments: [
            GaugeSegment(name: "Fed State",
                         description: "Your body is absorbing nutrients from food. Blood sugar rises, and insulin helps store energy.",
                         lengthInHours: 3,
                         color: .red),
            
            GaugeSegment(name: "Early Fasting",
                         description: "Blood sugar starts to drop, and the body begins using stored glycogen for energy.",
                         lengthInHours: 5,
                         color: .orange),
            
            GaugeSegment(name: "Fat Burning Starts",
                         description: "Glycogen stores run low, and the body slowly switches to burning fat for fuel.",
                         lengthInHours: 3,
                         color: .yellow),
            
            GaugeSegment(name: "Ketosis Begins",
                         description: "The body now mainly burns fat, producing ketones as an alternative energy source.",
                         lengthInHours: 3,
                         color: .green),
            
            GaugeSegment(name: "Autophagy",
                         description: "Your body removes damaged cells and starts deep cellular repair.",
                         lengthInHours: 2,
                         color: .blue)
        ]
    )
    
    var rotationAngle: Double {
        ((90 - (360 * descriptor.maxSize) * 0.5) + 180)
    }
    
    var body: some View {
        ZStack {
            // Full Circle Background
            Circle()
                .trim(from: 0, to: descriptor.maxSize)
                .stroke(currentPhase.color.gradient.opacity(0.1), style: StrokeStyle(lineWidth: 28, lineCap: .round))
                .rotationEffect(Angle(degrees: rotationAngle))
                .shadow(radius: 5)
            
            // Draw Each Segment Based on Time
            ForEach(descriptor.segments, id: \.name) { segment in
                let trimRange = descriptor.trimRange(for: segment)
                
                // Normalize timeSince to the range of [0, descriptor.maxSize]
                let normalizedTime = (timeSince / 16.0) * descriptor.maxSize
                let cappedEnd = min(trimRange.end, normalizedTime)
                
                // Draw the segment only if timeSince overlaps
                Circle()
                    .trim(from: trimRange.start, to: cappedEnd)
                    .stroke(segment.color.gradient, style: StrokeStyle(lineWidth: 28, lineCap: .round))
                    .rotationEffect(Angle(degrees: rotationAngle))
                    .rotationEffect(Angle(degrees: cappedEnd > trimRange.start ? 0 : -60))
                    .scaleEffect(cappedEnd > trimRange.start ? 1.0 : 4.0)
                    .onTapGesture {
                        withAnimation {
                            selectedPhase = segment
                            showInfo = true
                        }
                    }
            }
        }
        .overlay {
            VStack {
                Text("\(timeSince, specifier: "%.0f")")
                    .font(.system(size: timeSince + 50 - (timeSince > 16 ? timeSince * 1.025 : 0), weight: .black, design: .rounded))
                    .fontWeight(.black)
                    .contentTransition(.numericText(value: timeSince))
            }
        }
        .sheet(isPresented: $showInfo) {
            if let phase = selectedPhase {
                VStack(alignment: .center) {
                    Text(phase.description)
                }
                .padding()
                .navigationTitle(phase.name)
            }
        }
        .onChange(of: showInfo) {
            if !showInfo {
                selectedPhase = nil
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var timeSince: Double = 16
    
    TabView {
        GaugeView(timeSince: $timeSince)
    }
}
