//
//  GaugeSectionView.swift
//  HealthyTrack
//
//  Created by Yann Berton on 04.02.25.
//

import SwiftUI
import SwiftData
import AVFoundation


@available(iOS 18.0, *)
struct GaugeSectionView: View {
	@Query(sort: \FoodEntry.timestamp, order: .reverse) private var entries: [FoodEntry]
	@Environment(\.modelContext) private var modelContext
	@Binding var expandedFoodButton: Bool
	
	@Environment(GaugeObservable.self) private var gaugeObservable
	
	let logMealTip = LogAMealTip()
	
	var body: some View {
		GaugeView(gauge: gaugeObservable)
			.overlay {
				VStack {
					Spacer()
					if !expandedFoodButton {
						Button { } label: {
							Label("Add Food Entry", systemImage: "plus")
								.onTapGesture {
									addFoodEntry(type: .StandardMeal)
								}
								.onLongPressGesture {
									expandedFoodButton = true
								}
								.labelStyle(.iconOnly)
						}
						.buttonStyle(LargeRoundButtonStyle())
						.transition(.scale)
					} else {
						Button {
							addFoodEntry(type: .Sweets)
						} label: {
							Label("Add Food Entry", systemImage: "birthday.cake")
								.labelStyle(.iconOnly)
						}
						.buttonStyle(LargeRoundButtonStyle())
						.transition(.blurReplace)
					}
				}
				.popoverTip(logMealTip, arrowEdge: .top)
				.overlay {
					if expandedFoodButton {
						Button {
							addFoodEntry(type: .HeartyMeal)
						} label: {
							Label("Add Food Entry", systemImage: "fork.knife")
								.labelStyle(.iconOnly)
						}
						.buttonStyle(LargeRoundButtonStyle())
						.offset(x: 0, y: 220)
						.transition(.push(from: .bottom))
						
						Button {
							addFoodEntry(type: .Vegetables)
						} label: {
							Label("Add Food Entry", systemImage: "carrot")
								.labelStyle(.iconOnly)
						}
						.buttonStyle(LargeRoundButtonStyle())
						.offset(x: 100, y: 200)
						.transition(
							.asymmetric(
								insertion: .push(from: .trailing),
								removal: .push(from: .leading)
							)
						)
						
						Button {
							addFoodEntry(type: .Softdrink)
						} label: {
							Label("Add Food Entry", systemImage: "waterbottle")
								.labelStyle(.iconOnly)
						}
						.buttonStyle(LargeRoundButtonStyle())
						.offset(x: -100, y: 200)
						.transition(
							.asymmetric(
								insertion: .push(from: .leading),
								removal: .push(from: .trailing)
							)
						)
					}
				}
			}
			.sensoryFeedback(.impact(
				weight: .light),
				trigger: expandedFoodButton == true
			)
			.onChange(of: entries) {
				calcTimeSince()
			}
			.onChange(of: gaugeObservable.forceTriggerRecalc) {
				calcTimeSince()
			}
			.onAppear {
				calcTimeSince()
				if !entries.isEmpty {
					LogAMealTip.hasLoggedMeal = true
				}
			}
			.animation(.spring, value: gaugeObservable.timeSince)
	}
	
	func calcTimeSince() {
		gaugeObservable.timeSince = (
			entries.first?.timeIntervalSinceNowInHours
		) ?? 0.0
	}
	
	func addFoodEntry(type: FoodType) {
		let newEntry = FoodEntry(timestamp: Date(), type: type)
		modelContext.insert(newEntry)
		
		expandedFoodButton = false
		
		logMealTip.invalidate(reason: .actionPerformed)
		LogAMealTip.hasLoggedMeal = true
		
		do {
			try modelContext.save()
		} catch {
			print("Error saving new entry: \(error)")
		}
	}
}

@available(iOS 18.0, *)
#Preview {
	@Previewable @State var expandedFoodButton: Bool = false
	
	GaugeSectionView(expandedFoodButton: $expandedFoodButton)
		.modelContainer(for: FoodEntry.self)
}
