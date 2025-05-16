//
//  RecipeDetailsView.swift
//  recipeviewer
//
//  Created by Michael Wendell on 5/14/25.
//

import SwiftUI
import AVKit

//view to show more details about a recipe or offer to link to the source or
//Youtube if they are provided
struct RecipeDetailsView: View {
    @Environment(\.modelContext) private var modelContext
    let recipe : RecipeModel
    var body: some View {
        VStack{
            
            Text( recipe.name)
                .font(.title)
                .fontWeight(.semibold)
            Image(uiImage: recipe.viewLargeImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 350, maxHeight: 300)
                        .cornerRadius(8)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Cuisine: \(recipe.cuisine)")
                        .font(.subheadline)
                        .fontWeight(.light)
                }
                Spacer()
            }
            .padding(.leading, 30)
            .task {
                //retrieves and caches the larged image when viewed
                let bgActor = RecipeModel.BackgroundActor(modelContainer: modelContext.container)
                do {
                    await bgActor.downloadLargeImage(recipe: recipe)
                }
            }
            
            HStack {
                if recipe.source_url != nil {
                    Link(destination: URL(string: recipe.source_url!)!) {
                        Text("Recipe \n Source \n \(Image(systemName: "arrow.forward.circle"))")
                    }
                    .frame(width: 150, height: 150)
                    .background(.green)
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.bold)
                    .cornerRadius(8)
                }
                
                if recipe.youtube_url != nil {
                    Link(destination: URL(string: recipe.youtube_url!)!) {
                        Text("Youtube Recipe \n \(Image(systemName: "arrow.forward.circle"))")
                    }
                    .font(.title2)
                    .frame(width: 150, height: 150)
                    .background(.red)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .cornerRadius(8)
                }
                
            }
            .padding(.vertical, 10)
            
        }
        .frame(width: 375, height: 600)
        .background(Color(.systemBackground))
        .clipped()
        .cornerRadius(8)
        .shadow(radius: 8)

    }
}

#Preview {
    RecipeDetailsView(recipe: RecipeModel.init(cuisine: "British",
                                               name: "Apple & Blackberry Crumble",
                                               photo_url_large: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                                               photo_url_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                                               source_url: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                                               uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f",
                                               youtube_url: "https://www.youtube.com/watch?v=4vhcOwVBDO4"))
}
