//
//  FoodListView.swift
//  HealthyTrack
//
//  Created by Yann Berton on 04.02.25.
//

import SwiftUI
import SwiftData

@available(iOS 18.0, *)
struct FoodListView: View {
	@Query(sort: \FoodEntry.timestamp, order: .reverse) private var entries: [FoodEntry]
	@Environment(\.modelContext) private var modelContext
	
	@State var selectedEntry: FoodEntry?
	@State var showInspector: Bool = false
	
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
						selectedEntry = entry
						showInspector = true
					}
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
				showInspector = false
				selectedEntry = nil
			}
			.inspector(isPresented: $showInspector) {
				if let entry = selectedEntry {
					EditFoodEntryView(entry: entry)
				}
			}
			.onChange(of: showInspector) {
				if !showInspector {
					selectedEntry = nil
				}
			}
		}
	}
}

@available(iOS 18.0, *)
#Preview {
	FoodListView()
}
