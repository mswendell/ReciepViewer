//
//  recipeviewerApp.swift
//  recipeviewer
//
//  Created by Michael Wendell on 5/13/25.
//

import SwiftUI
import SwiftData

@main
struct recipeviewerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: RecipeModel.self)
        }
    }
}
