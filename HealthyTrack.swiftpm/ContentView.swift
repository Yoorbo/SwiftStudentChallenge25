import SwiftUI
import SwiftData

@available(iOS 18.0, *)
struct ContentView: View {
	@Query(sort: \FoodEntry.timestamp, order: .reverse) private var entries: [FoodEntry]
	
	@State var expandedFoodButton: Bool = false
	
	var body: some View {
		VStack {
			GaugeSectionView(expandedFoodButton: $expandedFoodButton)
				.frame(maxWidth: 350, maxHeight: 350)
				.padding(30)
			
			Spacer()
			
			FoodListView()
				.padding(.top, expandedFoodButton ? 100 : 0)
		}
		.animation(.spring, value: entries)
		.animation(.spring, value: expandedFoodButton)
		.navigationTitle("HealthyTrack")
	}
}
