//
//  ContentView.swift
//  caliber
//
//  Created by Aayush Agarwal on 7/10/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            ExercisesView()
                .tabItem { Label("Exercises", systemImage: "list.bullet") }
            HistoryView()
                .tabItem { Label("History", systemImage: "clock") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person") }
        }
        .task {
            SeedData.seedExercisesIfNeeded(in: modelContext)
            #if DEBUG
            SeedData.seedSampleHistoryIfNeeded(in: modelContext)
            #endif
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Exercise.self, WorkoutSession.self, SetEntry.self], inMemory: true)
}
