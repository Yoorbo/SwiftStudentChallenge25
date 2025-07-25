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
            Circle()
				.trim(from: 0, to: gauge.descriptor.maxSize)
				.stroke(gauge.currentPhase.color.gradient.opacity(0.1), style: StrokeStyle(lineWidth: 28, lineCap: .round))
				.rotationEffect(Angle(degrees: gauge.rotationAngle))
                .shadow(radius: 5)
            
			ForEach(gauge.descriptor.segments, id: \.name) { segment in
				let trimRange = gauge.descriptor.trimRange(for: segment)
                
				let normalizedTime = (gauge.timeSince / 16.0) * gauge.descriptor.maxSize
                let cappedEnd = min(trimRange.end, normalizedTime)
				
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
		.popover(isPresented: $gauge.showInfo, arrowEdge: .bottom) {
			if let phase = gauge.selectedPhase {
				VStack(alignment: .leading) {
					Text("What is '\(phase.name)'?")
						.font(.headline)
					Text(phase.description)
				}
				.padding()
				.navigationTitle(phase.name)
			}
		}
        .overlay {
            VStack {
				Text("\(gauge.timeSince, specifier: "%.0f")")
					.foregroundStyle(.primary)
					.font(.system(size: gauge.timeSince + 50 - (gauge.timeSince > 16 ? gauge.timeSince * 1.025 : 0), weight: .black, design: .rounded))
                    .fontWeight(.black)
					.contentTransition(.numericText(value: gauge.timeSince))
				Text("Hours since last meal")
					.foregroundStyle(.secondary)
            }
        }
		.onChange(of: gauge.showInfo) {
			if !gauge.showInfo {
				gauge.selectedPhase = nil
            }
        }
		.accessibilityLabel(Text("The IntervalRing: A Gauge Graph showing the hours since the last meal. The Gauge shows approximated metabolic phases. The current phase is \(gauge.currentPhase) and the last meal was \(gauge.timeSince) hours ago."))
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var timeSince: Double = 16
	
	@Previewable @State var gaugeObservable: GaugeObservable = GaugeObservable()
    
	GaugeView(gauge: gaugeObservable)
}
