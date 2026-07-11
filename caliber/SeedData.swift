//
//  SeedData.swift
//  caliber
//

import Foundation
import SwiftData

enum SeedData {
    /// Inserts the built-in exercise library if the store is empty. Safe to call on every launch.
    static func seedExercisesIfNeeded(in context: ModelContext) {
        let existingCount = (try? context.fetchCount(FetchDescriptor<Exercise>())) ?? 0
        guard existingCount == 0 else { return }

        for seed in exercises {
            context.insert(Exercise(name: seed.name, category: seed.category, equipment: seed.equipment))
        }
    }

    static let exercises: [(name: String, category: String, equipment: String)] = [
        ("Bench Press", "Chest", "Barbell"),
        ("Incline Dumbbell Press", "Chest", "Dumbbell"),
        ("Cable Fly", "Chest", "Cable"),

        ("Deadlift", "Back", "Barbell"),
        ("Pull-up", "Back", "Bodyweight"),
        ("Barbell Row", "Back", "Barbell"),

        ("Squat", "Legs", "Barbell"),
        ("Leg Press", "Legs", "Machine"),
        ("Romanian Deadlift", "Legs", "Barbell"),

        ("Overhead Press", "Shoulders", "Barbell"),
        ("Lateral Raise", "Shoulders", "Dumbbell"),
        ("Face Pull", "Shoulders", "Cable"),

        ("Bicep Curl", "Arms", "Dumbbell"),
        ("Tricep Pushdown", "Arms", "Cable"),
        ("Hammer Curl", "Arms", "Dumbbell"),

        ("Plank", "Core", "Bodyweight"),
        ("Crunch", "Core", "Bodyweight"),
        ("Hanging Leg Raise", "Core", "Bodyweight"),
    ]
}
