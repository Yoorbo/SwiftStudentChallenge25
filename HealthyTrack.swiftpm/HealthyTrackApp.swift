import SwiftUI
import TipKit

@available(iOS 18.0, *)
@main
struct HealthyTrackApp: App {
	init() {
		do {
			try Tips.configure()
		}
		catch {
			print("Error initializing tips: \(error)")
		}
	}
	
    var body: some Scene {
        WindowGroup {
				ContentView()
			.modelContainer(for: FoodEntry.self)
        }
    }
}
