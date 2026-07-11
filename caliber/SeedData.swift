//
//  SeedData.swift
//  caliber
//

import Foundation
import SwiftData
import os

enum SeedData {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "caliber", category: "SeedData")

    /// Inserts the built-in exercise library if the store is empty. Safe to call on every launch.
    static func seedExercisesIfNeeded(in context: ModelContext) {
        let existingCount: Int
        do {
            existingCount = try context.fetchCount(FetchDescriptor<Exercise>())
        } catch {
            logger.error("Failed to fetch existing exercise count: \(error)")
            return
        }
        guard existingCount == 0 else { return }

        for seed in exercises {
            context.insert(Exercise(name: seed.name, category: seed.category, equipment: seed.equipment))
        }
    }

    /// Inserts sample workout history if the store has no sessions yet. Safe to call on every launch.
    /// Assumes `seedExercisesIfNeeded` has already run so the referenced exercises exist.
    static func seedSampleHistoryIfNeeded(in context: ModelContext) {
        let existingCount: Int
        do {
            existingCount = try context.fetchCount(FetchDescriptor<WorkoutSession>())
        } catch {
            logger.error("Failed to fetch existing workout session count: \(error)")
            return
        }
        guard existingCount == 0 else { return }

        let allExercises: [Exercise]
        do {
            allExercises = try context.fetch(FetchDescriptor<Exercise>())
        } catch {
            logger.error("Failed to fetch exercises for sample history seeding: \(error)")
            return
        }
        guard !allExercises.isEmpty else { return }
        func exercise(named name: String) -> Exercise? {
            allExercises.first { $0.name == name }
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        for plan in sampleHistory {
            guard let date = calendar.date(byAdding: .day, value: -plan.daysAgo, to: today) else { continue }

            var order = 0
            var setEntries: [SetEntry] = []
            for (exerciseName, sets) in plan.exercises {
                guard let matchedExercise = exercise(named: exerciseName) else { continue }
                for (weight, reps) in sets {
                    setEntries.append(SetEntry(weight: weight, reps: reps, order: order, exercise: matchedExercise))
                    order += 1
                }
            }

            context.insert(WorkoutSession(date: date, setEntries: setEntries))
        }
    }

    static let sampleHistory: [(daysAgo: Int, exercises: [(name: String, sets: [(weight: Double, reps: Int)])])] = [
        (20, [
            ("Bench Press", [(135, 8), (145, 6), (155, 5)]),
            ("Barbell Row", [(115, 8), (125, 6), (125, 6)]),
            ("Plank", [(0, 60)]),
        ]),
        (18, [
            ("Squat", [(155, 8), (175, 6), (185, 5)]),
            ("Leg Press", [(270, 10), (290, 8)]),
        ]),
        (15, [
            ("Overhead Press", [(75, 8), (85, 6), (85, 6)]),
            ("Lateral Raise", [(15, 12), (15, 12), (15, 12)]),
            ("Face Pull", [(40, 15), (40, 15)]),
        ]),
        (13, [
            ("Deadlift", [(185, 5), (205, 5), (225, 3)]),
            ("Pull-up", [(0, 8), (0, 7), (0, 6)]),
        ]),
        (10, [
            ("Bench Press", [(140, 8), (150, 6), (160, 4)]),
            ("Cable Fly", [(30, 12), (30, 12)]),
            ("Tricep Pushdown", [(45, 12), (45, 12)]),
        ]),
        (8, [
            ("Squat", [(160, 8), (180, 6), (190, 5)]),
            ("Romanian Deadlift", [(135, 10), (145, 8)]),
        ]),
        (5, [
            ("Bicep Curl", [(25, 10), (25, 10), (25, 10)]),
            ("Hammer Curl", [(20, 10), (20, 10)]),
            ("Crunch", [(0, 20)]),
            ("Hanging Leg Raise", [(0, 12), (0, 10)]),
        ]),
        (2, [
            ("Incline Dumbbell Press", [(50, 10), (55, 8), (55, 8)]),
            ("Barbell Row", [(120, 8), (130, 6)]),
        ]),
    ]

    static let exercises: [(name: String, category: Exercise.Category, equipment: Exercise.Equipment)] = [
        ("Bench Press", .chest, .barbell),
        ("Incline Dumbbell Press", .chest, .dumbbell),
        ("Cable Fly", .chest, .cable),

        ("Deadlift", .back, .barbell),
        ("Pull-up", .back, .bodyweight),
        ("Barbell Row", .back, .barbell),

        ("Squat", .legs, .barbell),
        ("Leg Press", .legs, .machine),
        ("Romanian Deadlift", .legs, .barbell),

        ("Overhead Press", .shoulders, .barbell),
        ("Lateral Raise", .shoulders, .dumbbell),
        ("Face Pull", .shoulders, .cable),

        ("Bicep Curl", .arms, .dumbbell),
        ("Tricep Pushdown", .arms, .cable),
        ("Hammer Curl", .arms, .dumbbell),

        ("Plank", .core, .bodyweight),
        ("Crunch", .core, .bodyweight),
        ("Hanging Leg Raise", .core, .bodyweight),
    ]
}
