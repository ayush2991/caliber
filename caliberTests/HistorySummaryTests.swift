//
//  HistorySummaryTests.swift
//  caliberTests
//

import Testing
@testable import caliber

@MainActor
struct HistorySummaryTests {
    @Test func emptyEntriesFallsBackToNoSetsLogged() {
        let summary = HistorySummary.summary(for: [])
        #expect(summary == "No sets logged")
    }

    @Test func singleExerciseSingleSetUsesSingularLabel() {
        let exercise = Exercise(name: "Bench Press", category: .chest, equipment: .barbell)
        let entries = [SetEntry(weight: 135, reps: 5, order: 0, exercise: exercise)]

        let summary = HistorySummary.summary(for: entries)

        #expect(summary == "Bench Press · 1 set")
    }

    @Test func singleExerciseMultipleSetsUsesPluralLabel() {
        let exercise = Exercise(name: "Bench Press", category: .chest, equipment: .barbell)
        let entries = [
            SetEntry(weight: 135, reps: 5, order: 0, exercise: exercise),
            SetEntry(weight: 135, reps: 5, order: 1, exercise: exercise),
            SetEntry(weight: 135, reps: 5, order: 2, exercise: exercise),
        ]

        let summary = HistorySummary.summary(for: entries)

        #expect(summary == "Bench Press · 3 sets")
    }

    @Test func repeatedConsecutiveSetsOfSameExerciseAreNotDuplicatedInName() {
        let exercise = Exercise(name: "Squat", category: .legs, equipment: .barbell)
        let entries = [
            SetEntry(weight: 185, reps: 5, order: 0, exercise: exercise),
            SetEntry(weight: 185, reps: 5, order: 1, exercise: exercise),
        ]

        let summary = HistorySummary.summary(for: entries)

        #expect(summary == "Squat · 2 sets")
    }

    @Test func multipleExercisesAreListedInOrderWithoutDuplicates() {
        let squat = Exercise(name: "Squat", category: .legs, equipment: .barbell)
        let bench = Exercise(name: "Bench Press", category: .chest, equipment: .barbell)
        let entries = [
            SetEntry(weight: 185, reps: 5, order: 0, exercise: squat),
            SetEntry(weight: 185, reps: 5, order: 1, exercise: squat),
            SetEntry(weight: 135, reps: 5, order: 2, exercise: bench),
        ]

        let summary = HistorySummary.summary(for: entries)

        #expect(summary == "Squat, Bench Press · 3 sets")
    }

    @Test func sameExerciseAppearingNonConsecutivelyIsListedTwice() {
        let squat = Exercise(name: "Squat", category: .legs, equipment: .barbell)
        let bench = Exercise(name: "Bench Press", category: .chest, equipment: .barbell)
        let entries = [
            SetEntry(weight: 185, reps: 5, order: 0, exercise: squat),
            SetEntry(weight: 135, reps: 5, order: 1, exercise: bench),
            SetEntry(weight: 190, reps: 5, order: 2, exercise: squat),
        ]

        let summary = HistorySummary.summary(for: entries)

        #expect(summary == "Squat, Bench Press, Squat · 3 sets")
    }
}
