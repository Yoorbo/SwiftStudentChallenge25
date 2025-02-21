//
//  PhaseDisplayView.swift
//  HealthyTrack
//
//  Created by Yann Berton on 04.02.25.
//

import SwiftUI

@available(iOS 18.0, *)
struct PhaseDisplayView: View {
	@Environment(GaugeObservable.self) private var gaugeObservable
	
	@State var isExpanded: Bool = false
	
	var body: some View {
		VStack {
			HStack {
				VStack(alignment: .leading) {
					Text("Current approximated metabolic state:")
						.font(.footnote)
						.foregroundStyle(.tertiary)
					Text(gaugeObservable.currentPhase.name)
						.font(.headline)
				}
				Spacer()
				
				Image(systemName: "info")
					.fontWeight(.thin)
					.frame(width: 30, height: 30)
					.foregroundStyle(
						gaugeObservable.currentPhase.color.gradient
					)
					.symbolEffect(.bounce, value: isExpanded)
			}
			
			if isExpanded {
				HStack {
					Text(gaugeObservable.currentPhase.description)
						.font(.body)
						.foregroundStyle(.secondary)
						.multilineTextAlignment(.leading)
					Spacer()
				}
				.transition(.blurReplace)
			}
		}
		.animation(.spring, value: isExpanded)
		.padding(.horizontal, 15)
		.padding(.vertical, 10)
		.background(
			gaugeObservable.currentPhase.color.gradient.opacity(0.1)
		)
		.clipShape(RoundedRectangle(cornerRadius: 10))
		.overlay(
			RoundedRectangle(cornerRadius: 10)
				.stroke(gaugeObservable.currentPhase.color.gradient, lineWidth: 2)
		)
		.onTapGesture {
			isExpanded.toggle()
		}
	}
}
