//
//  GaugeTips.swift
//  HealthyTrack
//
//  Created by Yann Berton on 14.02.25.
//

import TipKit

@available(iOS 18.0, *)
struct EditMealTip: Tip {
	@Parameter
	static var hasEditedMeal: Bool = false
	
	var title: Text {
		Text("Edit and see more")
	}
	
	
	var message: Text? {
		Text("Click this entry to edit time and type.")
	}
	
	
	var image: Image? {
		Image(systemName: "pencil.circle")
	}
	
	var rules: [Rule] {
		#Rule(Self.$hasEditedMeal) {
			$0 == false
		}
	}
}

@available(iOS 18.0, *)
struct ChangeTimeTip: Tip {
	@Parameter
	static var hasChangedTime: Bool = false
	
	var title: Text {
		Text("Change time")
	}
	
	
	var message: Text? {
		Text("Change the time of your entry by clicking the time and see the IntervalRing move.")
	}
	
	
	var image: Image? {
		Image(systemName: "clock.circle")
	}
	
	var rules: [Rule] {
		#Rule(Self.$hasChangedTime) {
			$0 == false
		}
	}
}


@available(iOS 18.0, *)
struct ChangeTypeTip: Tip {
	@Parameter
	static var hasChangedType: Bool = false
	
	var title: Text {
		Text("Change meal type")
	}
	
	
	var message: Text? {
		Text("Press and hold to change the type of your logged meal.")
	}
	
	
	var image: Image? {
		Image(systemName: "gear.badge.questionmark")
	}
	
	var rules: [Rule] {
		#Rule(ChangeTimeTip.$hasChangedTime) {
			$0 == true
		}
		
		#Rule(Self.$hasChangedType) {
			$0 == false
		}
	}
}
