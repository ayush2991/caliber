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
                Text(session.date.formatted(date: .abbreviated, time: .shortened))
            }
            .navigationTitle("History")
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: [Exercise.self, WorkoutSession.self, SetEntry.self], inMemory: true)
}
