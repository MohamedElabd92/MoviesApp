# MoviesApp
After cloning the repository run **pod install** command then open MoviesApp.xcworkspace  
App developed using XCode 12.5.1 and Swift 5

### Features
- App consistes of 4 main tabs.
-- Now Playing
-- Top Rated
-- Search
-- Favorites
- Integration with [Movies API](https://developers.themoviedb.org/3/movies/get-now-playing) and displays data on each view controller.
- Favorites movies are saved in UserDefualts.
- Caching downloading images using NSCache.
- Main screens displays list of movies' poster, title and average rating. 
-- Each movie can be added to favorites list by tapping on favorite button.
- Details screen displays the selected movie details (movie image, title, average rating, rating count, genres, release date and movie description).

### CocoaPods Used
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [ProgressHUD](https://github.com/relatedcode/ProgressHUD)
