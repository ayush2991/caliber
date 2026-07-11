//
//  Exercise.swift
//  caliber
//

import Foundation
import SwiftData

@Model
final class Exercise {
    var name: String
    var category: String
    var equipment: String

    init(name: String, category: String, equipment: String) {
        self.name = name
        self.category = category
        self.equipment = equipment
    }
}
