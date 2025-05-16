import SwiftData
import UIKit
import Foundation

//recipe list to store array of recipe objects
struct RecipeList : Decodable {
    var recipes: [Recipe]
}

//model for recipe defining requred variables
struct Recipe: Decodable, Hashable {
        let cuisine: String
        let name: String
        let photo_url_large: String?
        let photo_url_small: String?
        let source_url: String?
        let uuid: String
        let youtube_url: String?
    
}

//model class of recipes to create a data cached recipe model
@Model
class RecipeModel {
    var cuisine: String
    var name: String
    var photo_url_large: String?
    var photo_url_small: String?
    var source_url: String?
    @Attribute(.unique)
    var uuid: String
    var youtube_url: String?
    //extra attributes to cache images after we access them
    @Attribute(.externalStorage)
    var imageLarge: Data?
    @Attribute(.externalStorage)
    var imageSmall: Data?
    
    init(cuisine: String, name: String, photo_url_large: String? = nil, photo_url_small: String? = nil, source_url: String? = nil, uuid: String, youtube_url: String? = nil) {
        self.cuisine = cuisine
        self.name = name
        self.photo_url_large = photo_url_large
        self.photo_url_small = photo_url_small
        self.source_url = source_url
        self.uuid = uuid
        self.youtube_url = youtube_url
        self.imageLarge = imageLarge
        self.imageSmall = imageSmall
    }
}

//extesion of the recipe model created to retrive and store data in modelContext
extension RecipeModel {
    @ModelActor
    actor BackgroundActor { //Background actor created to work in the backgorund to cache recipe data
        func importRecipes(urlString: String) async throws {
            //first set-up the url from the designated string
            guard let url = URL(string: urlString) else {
                return
            }
            do { //retrive the data from the url and use json decoder to retrive the list of recipes
                let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
                let decoder = JSONDecoder()
                let recipes = try decoder.decode(RecipeList.self, from: data)
                
                //loop through recipe list and create a model for each recipe and insert it into modelContext
                for recipe in recipes.recipes {
                    let recipeModel = RecipeModel(cuisine: recipe.cuisine, name: recipe.name, photo_url_large: recipe.photo_url_large, photo_url_small: recipe.photo_url_small, source_url: recipe.source_url, uuid: recipe.uuid, youtube_url: recipe.youtube_url)
                    
                    modelContext.insert(recipeModel)
                }
                // save all the recipes stored in model context
                try modelContext.save()
                
            }
            catch {
                print("Error downloading, parsing, or saving model info: \(error)")
            }
        }
        
        // function used to download the small images when the app is first launched
        func downloadSmallImage(recipe: RecipeModel) async {
            guard let url = URL(string: recipe.photo_url_small ?? "") else {
                return
            }
            
            do {
                //get the image from the url and then set it as the model image
                let (data, _) = try await URLSession.shared.data(from: url)
                recipe.imageSmall = data
            } catch {
                print("Error downloading imgae: \(error)")
            }
        do {
            try modelContext.save()
        } catch {
            print("Error saving context: \(error)")
            }
        }
        
        //function that uses the recpes url to retrive and store large image
        func downloadLargeImage(recipe: RecipeModel) async {
            guard let url = URL(string: recipe.photo_url_large ?? "") else {
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                recipe.imageLarge = data
            } catch {
                print("Error downloading imgae: \(error)")
            }
        do {
            try modelContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
        }
    }
    
    //ui large image vairble that will retrive the data and convert it into a UIImage for display
    var viewLargeImage: UIImage {
        guard let image = imageLarge else {
            return UIImage(systemName: "photo")!
        }
        return UIImage(data: image) ?? UIImage(systemName: "photo")!
    }
    
    //ui small image vairble that will retrive the data and convert it into a UIImage for display
    var viewSmallImage: UIImage {
        guard let image = imageSmall else {
            return UIImage(systemName: "photo")!
        }
        return UIImage(data: image) ?? UIImage(systemName: "photo")!
    }
}
