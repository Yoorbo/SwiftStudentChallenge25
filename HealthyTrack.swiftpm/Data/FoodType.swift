//
//  FoodType.swift
//  IntervalTrack
//
//  Created by Yann Berton on 28.01.25.
//

import SwiftUI

enum FoodType: CaseIterable, Codable {
    case HeartyMeal
    case Vegetables
    case Sweets
    case Softdrink
    case StandardMeal
    
    var color: Color {
        switch self {
        case .StandardMeal:
            return .gray
        case .HeartyMeal:
            return .blue
        case .Vegetables:
            return .green
        case .Sweets:
            return .purple
        case .Softdrink:
            return .mint
        }
    }
    
    var iconName: String {
        switch self {
        case .StandardMeal:
            return "takeoutbag.and.cup.and.straw"
        case .HeartyMeal:
            return "fork.knife"
        case .Vegetables:
            return "carrot"
        case .Sweets:
            return "birthday.cake"
        case .Softdrink:
            return "waterbottle"
        }
    }
    
    var name: String {
        switch self {
        case .StandardMeal:
            return "Unspecified Meal"
        case .HeartyMeal:
            return "Hearty Meal"
        case .Vegetables:
            return "Vegetables"
        case .Sweets:
            return "Sweets"
        case .Softdrink:
            return "Softdrink"
        }
    }
}

extension FoodType {
    static var validCases: [FoodType] {
        allCases.filter { $0 != .StandardMeal }
    }
}
