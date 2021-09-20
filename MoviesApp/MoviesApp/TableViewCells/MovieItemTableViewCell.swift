//
//  MovieItemTableViewCell.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 19/09/2021.
//

import UIKit

var imageCache = NSCache<NSString, UIImage>()

class MovieItemTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var starImage: UIImageView!
    
    var model: ResultsObject?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        initialSetup()
    }
    
    func initialSetup() {
        containerView.dropShadow()
        containerView.setCornerRadius(value: 5)
        
        movieImage.image = UIImage(named: "moviePlaceholder")
        movieTitle.text = ""
        movieRating.text = ""
        
        favoriteButton.setImage(UIImage(named: "heartOff")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.tintColor = .lightGray
    }
    
    func setData(model: ResultsObject) {
        self.model = model
        movieTitle.text = model.title
        movieRating.text = "\(model.vote_average ?? 0.0)"
        setFavoriteImage()
        
        // download poster image
        let imageUrl = getPosterUrl()
        
        if let image = imageCache.object(forKey: imageUrl as NSString) {
            self.movieImage.image = image
            self.movieImage.setCornerRadius(value: 5)
        } else {
            downloadImage(urlString: imageUrl) { data in
                if let data = data {
                    self.movieImage.image = UIImage(data: data)
                    self.movieImage.setCornerRadius(value: 5)
                }
            }
        }
    }
    
    func getPosterUrl() -> String {
        var imageSize = "w500"
        if !(configurationModel.images?.poster_sizes?.contains("w500") ?? false) {
            imageSize = "original"
        }
        
        return (configurationModel.images?.secure_base_url ?? "") + imageSize + (self.model?.poster_path ?? "")
    }
    
    func setFavoriteImage() {
        let list = Utility.getFavoriteMovies()
        var isFavorite = false
        
        for item in list where item.id == model?.id {
            isFavorite = true
        }
        
        if isFavorite {
            favoriteButton.setImage(UIImage(named: "heartOn"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "heartOff")?.withRenderingMode(.alwaysTemplate), for: .normal)
            favoriteButton.tintColor = .lightGray
        }
    }
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        if favoriteButton.image(for: .normal) == UIImage(named: "heartOn") {
            favoriteButton.setImage(UIImage(named: "heartOff")?.withRenderingMode(.alwaysTemplate), for: .normal)
            favoriteButton.tintColor = .lightGray
            
            if let model = self.model {
                Utility.removeFromFavoriteMovies(data: model)
            }
            
        } else {
            favoriteButton.setImage(UIImage(named: "heartOn"), for: .normal)
            
            if let model = self.model {
                Utility.addToFavoriteMovies(data: model)
            }
        }
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

