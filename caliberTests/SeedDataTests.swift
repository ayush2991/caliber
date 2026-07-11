//
//  SeedDataTests.swift
//  caliberTests
//

import Testing
import SwiftData
@testable import caliber

struct SeedDataTests {
    private func makeInMemoryContext() throws -> ModelContext {
        let container = try ModelContainer(
            for: Exercise.self, WorkoutSession.self, SetEntry.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return ModelContext(container)
    }

    @Test func seedingEmptyStoreInsertsAllExercises() throws {
        let context = try makeInMemoryContext()

        SeedData.seedExercisesIfNeeded(in: context)

        let count = try context.fetchCount(FetchDescriptor<Exercise>())
        #expect(count == SeedData.exercises.count)
    }

    @Test func seedingTwiceDoesNotDuplicate() throws {
        let context = try makeInMemoryContext()

        SeedData.seedExercisesIfNeeded(in: context)
        SeedData.seedExercisesIfNeeded(in: context)

        let count = try context.fetchCount(FetchDescriptor<Exercise>())
        #expect(count == SeedData.exercises.count)
    }

    @Test func deletingSessionCascadesToSetEntries() throws {
        let context = try makeInMemoryContext()

        let exercise = Exercise(name: "Bench Press", category: "Chest", equipment: "Barbell")
        let entry = SetEntry(weight: 135, reps: 5, order: 0, exercise: exercise)
        let session = WorkoutSession(setEntries: [entry])
        context.insert(exercise)
        context.insert(session)
        try context.save()

        context.delete(session)
        try context.save()

        let remainingEntries = try context.fetchCount(FetchDescriptor<SetEntry>())
        #expect(remainingEntries == 0)
    }
}
