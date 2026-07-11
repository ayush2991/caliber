//
//  ExercisesView.swift
//  caliber
//

import SwiftUI
import SwiftData

struct ExercisesView: View {
    @Query(sort: \Exercise.name) private var exercises: [Exercise]

    private var categoriesPresent: [Exercise.Category] {
        Exercise.Category.allCases.filter { category in
            exercises.contains { $0.category == category }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(categoriesPresent, id: \.self) { category in
                    Section(category.rawValue) {
                        ForEach(exercises.filter { $0.category == category }) { exercise in
                            VStack(alignment: .leading) {
                                Text(exercise.name)
                                Text(exercise.equipment.rawValue)
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
