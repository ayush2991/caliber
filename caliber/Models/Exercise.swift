//
//  Exercise.swift
//  caliber
//

import Foundation
import SwiftData

@Model
final class Exercise {
    var name: String
    var category: Category
    var equipment: Equipment

    init(name: String, category: Category, equipment: Equipment) {
        self.name = name
        self.category = category
        self.equipment = equipment
    }

    enum Category: String, Codable, CaseIterable {
        case chest = "Chest"
        case back = "Back"
        case legs = "Legs"
        case shoulders = "Shoulders"
        case arms = "Arms"
        case core = "Core"
    }

    enum Equipment: String, Codable, CaseIterable {
        case barbell = "Barbell"
        case dumbbell = "Dumbbell"
        case cable = "Cable"
        case machine = "Machine"
        case bodyweight = "Bodyweight"
    }
}
