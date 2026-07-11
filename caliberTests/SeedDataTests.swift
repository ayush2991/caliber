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

    @Test func seedingSampleHistoryInsertsSessionsWithLinkedExercises() throws {
        let context = try makeInMemoryContext()
        SeedData.seedExercisesIfNeeded(in: context)

        SeedData.seedSampleHistoryIfNeeded(in: context)

        let sessions = try context.fetch(FetchDescriptor<WorkoutSession>())
        #expect(sessions.count == SeedData.sampleHistory.count)

        let entries = try context.fetch(FetchDescriptor<SetEntry>())
        #expect(!entries.isEmpty)
        #expect(entries.allSatisfy { $0.exercise != nil })
    }

    @Test func seedingSampleHistoryTwiceDoesNotDuplicate() throws {
        let context = try makeInMemoryContext()
        SeedData.seedExercisesIfNeeded(in: context)

        SeedData.seedSampleHistoryIfNeeded(in: context)
        SeedData.seedSampleHistoryIfNeeded(in: context)

        let count = try context.fetchCount(FetchDescriptor<WorkoutSession>())
        #expect(count == SeedData.sampleHistory.count)
    }

    @Test func deletingSessionCascadesToSetEntries() throws {
        let context = try makeInMemoryContext()

        let exercise = Exercise(name: "Bench Press", category: .chest, equipment: .barbell)
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
