//
//  HistoryView.swift
//  caliber
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]

    var body: some View {
        NavigationStack {
            List(sessions) { session in
                VStack(alignment: .leading) {
                    Text(session.date.formatted(date: .abbreviated, time: .omitted))
                    Text(summary(for: session))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("History")
        }
    }

    private func summary(for session: WorkoutSession) -> String {
        let exerciseNames = session.setEntries
            .sorted { $0.order < $1.order }
            .compactMap { $0.exercise?.name }
            .reduce(into: [String]()) { result, name in
                if result.last != name { result.append(name) }
            }

        guard !exerciseNames.isEmpty else { return "No sets logged" }

        let setCount = session.setEntries.count
        let setLabel = setCount == 1 ? "set" : "sets"
        return "\(exerciseNames.joined(separator: ", ")) · \(setCount) \(setLabel)"
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: [Exercise.self, WorkoutSession.self, SetEntry.self], inMemory: true)
}
