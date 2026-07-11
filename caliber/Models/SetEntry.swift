//
//  SetEntry.swift
//  caliber
//

import Foundation
import SwiftData

@Model
final class SetEntry {
    var weight: Double
    var reps: Int
    var order: Int
    var exercise: Exercise?
    var session: WorkoutSession?

    init(weight: Double, reps: Int, order: Int, exercise: Exercise? = nil) {
        self.weight = weight
        self.reps = reps
        self.order = order
        self.exercise = exercise
    }
}
