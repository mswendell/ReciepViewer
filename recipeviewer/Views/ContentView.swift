//
//  ContentView.swift
//  recipeviewer
//
//  Created by Michael Wendell on 5/13/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //model context enviornment where the recipe data is cached
    @Environment(\.modelContext) private var modelContext
    //query to retrive the data sorted by recipe name
    @Query(sort: \RecipeModel.name) private var recipes: [RecipeModel]
    //different url to retrieve recipes from
    let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    //let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    //let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    var body: some View {
        //stack for diplaying recipes and novigation to details
        NavigationStack {
            if recipes.isEmpty { // displays prompt if no data is present
                Spacer()
                Text("No Reciepes Found")
            }
            List {
                ForEach (recipes, id: \.uuid) {recipe in
                    NavigationLink(value: recipe) {
                        RecipeView(recipe: recipe)
                    }
                }
            }
            .navigationTitle("Recipe List")
            .refreshable { // allows user to try to refresh the data
                await fetchData()
            }
            .navigationDestination(for: RecipeModel.self){ recipe in
                RecipeDetailsView(recipe: recipe)}
        }
        .task(priority: .background) {
            await fetchData() //fetchs the data when the app is initally launched
        }
    }
    
    //function to set-up the RecipeModel and import the data
    func fetchData() async {
        //creates a background actor instance with modelContext then imports the recipes
        let bgActor = RecipeModel.BackgroundActor(modelContainer: modelContext.container)
        do {
            try await bgActor.importRecipes(urlString: urlString)
        } catch {
            print("error loading data: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: RecipeModel.self)
}


