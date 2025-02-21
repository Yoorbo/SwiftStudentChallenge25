//
//  EditFoodEntryView.swift
//  IntervalTrack
//
//  Created by Yann Berton on 28.01.25.
//


import SwiftUI
import SwiftData
import TipKit

@available(iOS 18.0, *)
struct EditFoodEntryView: View {
    @Bindable var entry: FoodEntry
    
    @State var timeSince: String = ""
    @State var viewUpdateCounter: Double = 0.0
	
    @State var editType: Bool = false
	
	@Environment(\.modelContext) private var modelContext
	
	@Environment(GaugeObservable.self) private var gaugeObservable
	
	let changeTimeTip = ChangeTimeTip()
    
    var body: some View {
		ScrollView {
            Spacer()
			HStack {
				Circle()
					.frame(width: 60)
					.foregroundStyle(entry.type.color.gradient)
					.overlay {
						Image(systemName: entry.type.iconName)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 35, height: 35)
							.foregroundStyle(.white)
					}
				VStack(alignment: .leading) {
					Text(entry.type.name)
						.font(.title3)
						.foregroundStyle(.primary)
					Text(timeSince)
						.font(.headline)
						.foregroundStyle(.secondary)
						.contentTransition(.numericText(value: viewUpdateCounter))
				}
				Spacer()
				
				Button {
					editType.toggle()
				} label: {
					Label("Change entry type", systemImage: editType ? "clock" : "gear")
						.labelStyle(.iconOnly)
						.symbolEffect(.rotate, value: editType)
						.symbolEffect(.bounce, value: editType)
				}
				.buttonStyle(SmallRoundButtonStyle())
				.tint(.gray.opacity(0.3))
				.foregroundStyle(.primary)
				
				Button {
					modelContext.delete(entry)
				} label: {
					Label("Delete entry", systemImage: "trash")
						.labelStyle(.iconOnly)
				}
				.buttonStyle(SmallRoundButtonStyle())
				.tint(.red)
			}
            
            
            Spacer()
			
			if editType {
				Picker("Type", selection: $entry.type) {
					ForEach(FoodType.validCases, id: \.self) { foodType in
						Text(foodType.name)
							.tag(foodType)
					}
				}
				.pickerStyle(.wheel)
				.transition(.slide)
			} else {
				VStack {
					TipView(changeTimeTip, arrowEdge: .bottom)
					DatePicker("Change time", selection: $entry.timestamp, displayedComponents: .hourAndMinute)
						.padding(.top, 30)
						.padding(.horizontal, 10)
						.padding(.bottom, 10)
					
					DatePicker(
						"Change date",
						selection: $entry.timestamp,
						displayedComponents: [.date]
					)
					.datePickerStyle(.graphical)
				}
				.transition(.slide)
			}
        }
		.padding()
        .transition(.blurReplace)
        .onAppear {
            timeSince = entry.timestamp.formatted(.relative(presentation: .numeric))
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            withAnimation {
                timeSince = entry.timestamp.formatted(.relative(presentation: .numeric))
                viewUpdateCounter += 1
            }
        }
		.animation(.spring, value: editType)
		.onChange(of: entry.timestamp) {
			gaugeObservable.forceTriggerRecalc += 1
			ChangeTimeTip.hasChangedTime = true
		}
    }
}

@available(iOS 18.0, *)
#Preview {
    @Previewable @State var entry: FoodEntry = FoodEntry(timestamp: Date.now, type: .Softdrink)
    
	EditFoodEntryView(entry: entry)
}
