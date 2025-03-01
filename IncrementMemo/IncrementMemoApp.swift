//
//  IncrementMemoApp.swift
//  IncrementMemo
//
//  Created by Kei on 2024/10/30.
//

import SwiftUI
import SwiftData

@main
struct IncrementMemoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
          MemoItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
