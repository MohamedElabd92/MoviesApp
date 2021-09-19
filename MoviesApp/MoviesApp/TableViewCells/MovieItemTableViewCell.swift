//
//  MovieItemTableViewCell.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 19/09/2021.
//

import UIKit

class MovieItemTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var starImage: UIImageView!
    
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
        movieTitle.text = "Title"
        movieRating.text = "Rating"
        
        setImage(isFavorite: false)
    }
    
    func setImage(isFavorite: Bool) {
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
        } else {
            favoriteButton.setImage(UIImage(named: "heartOn"), for: .normal)
        }
    }
    
}

