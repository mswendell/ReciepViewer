//
//  SwiftUIView.swift
//  recipeviewer
//
//  Created by Michael Wendell on 5/14/25.
//

import SwiftUI

// small cards displaying the small image, name, and cuisine of the recipe
struct RecipeView: View {
    @Environment(\.modelContext) private var modelContext
    let recipe : RecipeModel
    var body: some View {
        HStack {
            Image(uiImage: recipe.viewSmallImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 150, maxHeight: 130)
                    .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.title2)
                    .fontWeight(.medium)
                Text(recipe.cuisine)
                    .foregroundColor(.secondary)
            }
        }
        .task {
            //Retrives and caches small image for the recipe
            let bgActor = RecipeModel.BackgroundActor(modelContainer: modelContext.container)
            do {
                await bgActor.downloadSmallImage(recipe: recipe)
            }
        }

        
    }
}

#Preview {
    RecipeView(recipe: RecipeModel.init(cuisine: "British",
                                        name: "Apple & Blackberry Crumble",
                                        photo_url_large: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                                        photo_url_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                                        source_url: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                                        uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f",
                                        youtube_url: "https://www.youtube.com/watch?v=4vhcOwVBDO4"))
}
