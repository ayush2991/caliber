//
//  caliberApp.swift
//  caliber
//
//  Created by Aayush Agarwal on 7/10/26.
//

import SwiftUI
import SwiftData

@main
struct caliberApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Exercise.self, WorkoutSession.self, SetEntry.self])
    }
}
