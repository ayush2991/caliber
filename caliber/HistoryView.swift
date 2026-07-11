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
                    Text(HistorySummary.summary(for: session.setEntries))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("History")
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: [Exercise.self, WorkoutSession.self, SetEntry.self], inMemory: true)
}
