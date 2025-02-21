//
//  FoodListView.swift
//  HealthyTrack
//
//  Created by Yann Berton on 04.02.25.
//

import SwiftUI
import SwiftData
import Observation

@available(iOS 18.0, *)
@Observable
class ListState {
	var selectedEntry: FoodEntry?
	var showInspector: Bool = false
}

@available(iOS 18.0, *)
struct FoodListView: View {
	@Query(sort: \FoodEntry.timestamp, order: .reverse) private var entries: [FoodEntry]
	@Environment(\.modelContext) private var modelContext
	
	@State var listState = ListState()
	
	var body: some View {
		if !entries.isEmpty {
			VStack {
				HStack {
					VStack(alignment: .leading) {
						Divider()
							.padding(.bottom)
						Text("Last Meals")
							.font(.headline)
							.foregroundStyle(.primary)
						Text("See and edit your last logged meals")
							.font(.subheadline)
							.foregroundStyle(.secondary)
					}
					.padding(.horizontal, 22)
					Spacer()
				}
				.padding(.bottom, 1)
				
				List(entries) { entry in
					FoodEntryView(entry: entry, listState: $listState)
				}
				.listStyle(.plain)
				.listRowSpacing(0)
			}
			.transition(
				.asymmetric(
					insertion: .push(from: .bottom),
					removal: .opacity
				)
			)
			.onChange(of: entries) {
				listState.showInspector = false
				listState.selectedEntry = nil
			}
			.inspector(isPresented: $listState.showInspector) {
				if let entry = listState.selectedEntry {
					EditFoodEntryView(entry: entry)
				}
			}
			.onChange(of: listState.showInspector) {
				if !listState.showInspector {
					listState.selectedEntry = nil
				}
			}
		}
	}
}


@available(iOS 18.0, *)
struct FoodEntryView: View {
	let entry: FoodEntry
	@Binding var listState: ListState
	@Environment(\.modelContext) private var modelContext
	
	var body: some View {
		HStack {
			Image(systemName: entry.type.iconName)
				.foregroundStyle(entry.type.color)
			VStack(alignment: .leading) {
				Text(entry.type.name)
					.font(.headline)
					.foregroundStyle(.primary)
				Text("\(entry.timestamp, style: .date) at \(entry.timestamp, style: .time)")
					.font(.caption)
					.foregroundColor(.secondary)
			}
			Spacer()
			Image(systemName: "pencil")
				.font(.headline)
				.foregroundStyle(.secondary)
			Image(systemName: "chevron.right")
				.font(.headline)
				.foregroundStyle(.primary)
		}
		.contextMenu {
			ControlGroup {
				ForEach(FoodType.validCases.reversed(), id: \.self) { type in
					Button {
						entry.type = type
					} label: {
						Label(type.name, systemImage: type.iconName)
					}
				}
			} label: {
				Label("Change meal type", systemImage: "control")
					.labelStyle(.titleAndIcon)
			}
			ControlGroup {
				Button {
					listState.selectedEntry = entry
					listState.showInspector = true
				} label: {
					Label("Edit", systemImage: "pencil")
				}
			} label: {
				Label("More options", systemImage: "control")
					.labelStyle(.titleAndIcon)
			}
		}
		.listRowSeparator(.hidden)
		.padding()
		.background(.thinMaterial)
		.swipeActions(edge: .trailing) {
			Button(role: .destructive) {
				modelContext.delete(entry)
			} label: {
				Label("Delete", systemImage: "trash")
			}
			.tint(.red)
		}
		.clipShape(RoundedRectangle(cornerRadius: 18))
		.frame(height: 55)
		.onTapGesture {
			listState.selectedEntry = entry
			listState.showInspector = true
		}
	}
}

@available(iOS 18.0, *)
#Preview {
	FoodListView()
}
