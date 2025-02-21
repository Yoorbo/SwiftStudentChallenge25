//
//  FoodEntry.swift
//  IntervalTrack
//
//  Created by Yann Berton on 28.01.25.
//

import Foundation
import SwiftData

@available(iOS 17.0, *)
@Model
class FoodEntry {
    var timestamp: Date = Date()
    var type: FoodType = FoodType.StandardMeal
    
    init(timestamp: Date, type: FoodType) {
        self.timestamp = timestamp
        self.type = type
    }
}

@available(iOS 17.0, *)
extension FoodEntry {
    var timeIntervalSinceNowInHours: Double {
        Date().timeIntervalSince(timestamp) / 3600
    }
}
