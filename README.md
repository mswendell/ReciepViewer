### Summary:
My recipe app is fairly simple. On launch, it will display the provided list of recipes to users with an image, name, and cuisine. By pressing on any of the recipes, the user will be redirected to a detail view that provides a larger image as well as the ability to access the recipe source or youtube video of the recipe. The images displayed are each retrieved and cached by a background actor as the user navigates through the app.

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I prioritized the need for the project to have cached information and the ability for it to load images only when needed. It took a while to figure out the implementation with 
modelContext, but eventually I figured it out. I wanted to prioritize this because efficient network usage is important when designing modern applications. It's important for users to have applications that load and retrieve data seamlessly since freezing or hitching can be bothersome.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time? 
I spent around 12 hours working on this project. Initially, I wasn't planning on spending as much time, but there were a few areas where I needed to learn updated functionalities that increased the amount of time I was expecting to spend. I allocated most of my time to 

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
I would say the one tradeoff that I made was that the application is fairly simple in its look and design. In order to allocate my time well I spent more time ensuring that the apps retrieval and caching worked well instead of being very creative with the design features.

### Weakest Part of the Project: What do you think is the weakest part of your project?
I would consider the weakest part of the project to be the test coverage cases. I found it somewhat difficult to try to test all the pieces of data retrieval and caching, so it ended up being done with only a few test cases. If I had more time, I would reorganize the Recipe model to use functions that could be separately tested. 

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
Thank you for checking out my project!

