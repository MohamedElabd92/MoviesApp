//
//  DetailsViewController.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 20/09/2021.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieGeners: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    
    var result: ResultsObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setData()
    }
 
    func setData() {
        self.title = result?.title
        movieTitle.text = result?.title
        movieDate.text = result?.release_date
        movieDescription.text = result?.overview
        
        setMovieImage()
        setRatingText()
        setGenresText()
    }
    
    func setGenresText() {
        movieGeners.text = ""
        for item in genreListModel.genres ?? [] {
            if let id = item.id, let name = item.name, result?.genre_ids?.contains(id) ?? false {
                movieGeners.text?.append(name)
                movieGeners.text?.append(", ")
            }
        }
        
        if movieGeners.text?.trimmingCharacters(in: .whitespaces).last == "," {
            movieGeners.text?.removeLast(2)
        }
    }
    
    func setRatingText() {
        let average = result?.vote_average ?? 0.0
        let count = result?.vote_count ?? 0
        
        movieRating.text = "\(average) (\(count) Votes)"
    }
    
    func setMovieImage() {
        let imageUrl = getImageUrl()
        
        if let image = imageCache.object(forKey: imageUrl as NSString) {
            self.movieImageView.image = image
            self.movieImageView.setCornerRadius(value: 5)
        } else {
            downloadImage(urlString: imageUrl) { data in
                if let data = data {
                    self.movieImageView.image = UIImage(data: data)
                    self.movieImageView.setCornerRadius(value: 5)
                }
            }
        }
    }
    
    func getImageUrl() -> String {
        var imageSize = "w780"
        if !(configurationModel.images?.backdrop_sizes?.contains("w780") ?? false) {
            imageSize = "original"
        }
        
        return (configurationModel.images?.secure_base_url ?? "") + imageSize + (self.result?.backdrop_path ?? "")
    }
    
    func downloadImage(urlString: String, completion: @escaping (_ response: Data?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, _) -> Void in
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            print("Image downloaded successfully. url = \(urlString)")
                        } else {
                            print("Failed to download image. url = \(urlString)")
                        }
                    }
                    
                    DispatchQueue.main.async {
                        if let data = data {
                            completion(data)
                            imageCache.setObject(UIImage(data: data) ?? UIImage(), forKey: urlString as NSString)
                        }
                    }
                }.resume()
            }
        }
    }
}
