//
//  HistorySummary.swift
//  caliber
//

import Foundation

enum HistorySummary {
    static func summary(for entries: [SetEntry]) -> String {
        let exerciseNames = entries
            .sorted { $0.order < $1.order }
            .compactMap { $0.exercise?.name }
            .reduce(into: [String]()) { result, name in
                if result.last != name { result.append(name) }
            }

        guard !exerciseNames.isEmpty else { return "No sets logged" }

        let setCount = entries.count
        let setLabel = setCount == 1 ? "set" : "sets"
        return "\(exerciseNames.joined(separator: ", ")) · \(setCount) \(setLabel)"
    }
}
