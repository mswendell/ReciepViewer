//
//  recipeviewerTests.swift
//  recipeviewerTests
//
//  Created by Michael Wendell on 5/13/25.
//

import Testing
import SwiftData
@testable import recipeviewer

@MainActor
struct recipeviewerTests {
    let container: ModelContainer
    
    // setup the model and the container for testing
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        self.container = try ModelContainer(for: RecipeModel.self, configurations: config)
    }

    //tests that the importing works and imports recipes
    @Test func testImportRecipes() async throws {
        let modelContext = ModelContext(container)
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        let datamodel = RecipeModel.BackgroundActor(modelContainer: container)
        try await datamodel.importRecipes(urlString: urlString)
        let recipeList = try modelContext.fetch(FetchDescriptor<RecipeModel>())
        #expect(recipeList.count > 0)
        try container.erase()
    }
    
    //tests retreval of malformed data and that it is not saved if malformed
    @Test func testMalformedRecipes() async throws {
        let modelContext = ModelContext(container)
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        let datamodel = RecipeModel.BackgroundActor(modelContainer: container)
        try await datamodel.importRecipes(urlString: urlString)
        let recipeList = try modelContext.fetch(FetchDescriptor<RecipeModel>())
        #expect(recipeList.count == 0)
        try container.erase()
    }
    
    //test retreval of empty data
    @Test func testEmptyrecipe() async throws {
        let modelContext = ModelContext(container)
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        let datamodel = RecipeModel.BackgroundActor(modelContainer: container)
        try await datamodel.importRecipes(urlString: urlString)
        let recipeList = try modelContext.fetch(FetchDescriptor<RecipeModel>())
        #expect(recipeList.count == 0)
        try container.erase()
    }
    
    
    //tests that recipe info is being saved
    @Test func testRecipeInfo() async throws {
        let modelContext = ModelContext(container)
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        let datamodel = RecipeModel.BackgroundActor(modelContainer: container)
        try await datamodel.importRecipes(urlString: urlString)
        let recipeList = try modelContext.fetch(FetchDescriptor<RecipeModel>())
        #expect(!recipeList.first!.name.isEmpty)
        #expect(!recipeList.first!.uuid.isEmpty)
        #expect(!recipeList.first!.cuisine.isEmpty)
        try container.erase()
    }
    
    //test largeimage retreval
    @Test func testLargeImages() async throws {
        let recipe = RecipeModel.init(cuisine: "Food", name: "Food", photo_url_large: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", uuid: "")
        let datamodel = RecipeModel.BackgroundActor(modelContainer: container)
        await datamodel.downloadLargeImage(recipe: recipe)
        #expect(recipe.imageLarge != nil)
    }
    
    //test small image retreval
    @Test func testSmallImages() async throws {
        let recipe = RecipeModel.init(cuisine: "Food", name: "Food", photo_url_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", uuid: "")
        let datamodel = RecipeModel.BackgroundActor(modelContainer: container)
        await datamodel.downloadSmallImage(recipe: recipe)
        #expect(recipe.imageSmall != nil)
    }
}
