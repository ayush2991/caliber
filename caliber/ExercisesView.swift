//
//  ExercisesView.swift
//  caliber
//

import SwiftUI
import SwiftData

struct ExercisesView: View {
    @Query(sort: \Exercise.name) private var exercises: [Exercise]

    private var categories: [String] {
        Array(Set(exercises.map(\.category))).sorted()
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(categories, id: \.self) { category in
                    Section(category) {
                        ForEach(exercises.filter { $0.category == category }) { exercise in
                            VStack(alignment: .leading) {
                                Text(exercise.name)
                                Text(exercise.equipment)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Exercises")
        }
    }
}

#Preview {
    ExercisesView()
        .modelContainer(for: [Exercise.self, WorkoutSession.self, SetEntry.self], inMemory: true)
}
