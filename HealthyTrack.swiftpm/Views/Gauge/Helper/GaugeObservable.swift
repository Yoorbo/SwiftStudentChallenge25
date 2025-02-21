//
//  GaugeObservable.swift
//  HealthyTrack
//
//  Created by Yann Berton on 04.02.25.
//

import Observation


@available(iOS 17.0, *)
@Observable
class GaugeObservable {
	var timeSince: Double = 0.0
	
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
	
	var showInfo: Bool = false
	var selectedPhase: GaugeSegment?
	
	var forceTriggerRecalc: Int = 0
	
	var descriptor = GaugeDescriptor(
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
}
