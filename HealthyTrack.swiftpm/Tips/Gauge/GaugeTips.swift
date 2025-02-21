//
//  GaugeTips.swift
//  HealthyTrack
//
//  Created by Yann Berton on 14.02.25.
//

import TipKit

@available(iOS 18.0, *)
struct LogAMealTip: Tip {
	@Parameter
	static var hasLoggedMeal: Bool = false
	
	var title: Text {
		Text("Log a meal")
	}
	
	
	var message: Text? {
		Text("To log a meal, click on the plus button")
	}
	
	
	var image: Image? {
		Image(systemName: "fork.knife")
	}
	
	var rules: [Rule] {
		#Rule(Self.$hasLoggedMeal) {
			$0 == false
		}
	}
}

@available(iOS 18.0, *)
struct LongPressTip: Tip {
	@Parameter
	static var unspecifiedButtonPresses: Int = 0
	
	var title: Text {
		Text("Specify type on creation")
	}
	
	
	var message: Text? {
		Text("Press and hold the plus button to specify the logged type")
	}
	
	
	var image: Image? {
		Image(systemName: "gear.badge.questionmark")
	}
	
	var rules: [Rule] {
		#Rule(Self.$unspecifiedButtonPresses) {
			$0 >= 3
		}
	}
}

