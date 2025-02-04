//
//  GaugeView.swift
//  IntervalTrack
//
//  Created by Yann Berton on 28.01.25.
//

import SwiftUI

@available(iOS 17.0, *)
struct GaugeView: View {
	@Bindable var gauge: GaugeObservable
    
    var body: some View {
        ZStack {
            // Full Circle Background
            Circle()
				.trim(from: 0, to: gauge.descriptor.maxSize)
				.stroke(gauge.currentPhase.color.gradient.opacity(0.1), style: StrokeStyle(lineWidth: 28, lineCap: .round))
				.rotationEffect(Angle(degrees: gauge.rotationAngle))
                .shadow(radius: 5)
            
            // Draw Each Segment Based on Time
			ForEach(gauge.descriptor.segments, id: \.name) { segment in
				let trimRange = gauge.descriptor.trimRange(for: segment)
                
                // Normalize timeSince to the range of [0, descriptor.maxSize]
				let normalizedTime = (gauge.timeSince / 16.0) * gauge.descriptor.maxSize
                let cappedEnd = min(trimRange.end, normalizedTime)
                
                // Draw the segment only if timeSince overlaps
                Circle()
                    .trim(from: trimRange.start, to: cappedEnd)
                    .stroke(segment.color.gradient, style: StrokeStyle(lineWidth: 28, lineCap: .round))
					.rotationEffect(Angle(degrees: gauge.rotationAngle))
                    .rotationEffect(Angle(degrees: cappedEnd > trimRange.start ? 0 : -60))
                    .scaleEffect(cappedEnd > trimRange.start ? 1.0 : 4.0)
                    .onTapGesture {
                        withAnimation {
							gauge.selectedPhase = segment
							gauge.showInfo = true
                        }
                    }
            }
        }
        .overlay {
            VStack {
				Text("\(gauge.timeSince, specifier: "%.0f")")
					.font(.system(size: gauge.timeSince + 50 - (gauge.timeSince > 16 ? gauge.timeSince * 1.025 : 0), weight: .black, design: .rounded))
                    .fontWeight(.black)
					.contentTransition(.numericText(value: gauge.timeSince))
            }
        }
		.sheet(isPresented: $gauge.showInfo) {
			if let phase = gauge.selectedPhase {
                VStack(alignment: .center) {
                    Text(phase.description)
                }
                .padding()
                .navigationTitle(phase.name)
            }
        }
		.onChange(of: gauge.showInfo) {
			if !gauge.showInfo {
				gauge.selectedPhase = nil
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var timeSince: Double = 16
	
	@Previewable @State var gaugeObservable: GaugeObservable = GaugeObservable()
    
	GaugeView(gauge: gaugeObservable)
}
