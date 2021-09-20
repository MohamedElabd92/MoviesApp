//
//  FavoritesViewController.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 19/09/2021.
//

import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var emptyStateConatinerView: UIView!
    @IBOutlet weak var imageVerticalConstraint: NSLayoutConstraint!
    
    var results = [ResultsObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoriteButtonDidTapped()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        if imageVerticalConstraint != nil {
            if (UIWindow.isLandscape) {
                imageVerticalConstraint.constant = -100
            } else {
                imageVerticalConstraint.constant = 0
            }
        }
    }
    
    func initialSetup() {
        self.title = "Favorites"
        
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        
        registerCells()
    }
    
    func registerCells() {
        self.favoriteTableView.register(UINib(nibName: "MovieItemTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieItemTableViewCell")
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = favoriteTableView.dequeueReusableCell(withIdentifier: "MovieItemTableViewCell", for: indexPath) as? MovieItemTableViewCell {
            cell.dataDelegate = self
            cell.setData(model: results[indexPath.row])
            return cell
         }
         return UITableViewCell()
    }
}

extension FavoritesViewController: MovieItemCellDelegate {
    func favoriteButtonDidTapped() {
        results = Utility.getFavoriteMovies()
        
        if results.isEmpty {
            favoriteTableView.isHidden = true
            emptyStateConatinerView.isHidden = false
        } else {
            favoriteTableView.isHidden = false
            emptyStateConatinerView.isHidden = true
            favoriteTableView.reloadData()
        }
    }
}
