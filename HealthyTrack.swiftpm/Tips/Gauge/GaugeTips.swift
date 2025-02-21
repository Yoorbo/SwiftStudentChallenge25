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
