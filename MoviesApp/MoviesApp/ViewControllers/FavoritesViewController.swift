//
//  FavoritesViewController.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 19/09/2021.
//

import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet weak var favoriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialSetup()
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = favoriteTableView.dequeueReusableCell(withIdentifier: "MovieItemTableViewCell", for: indexPath) as? MovieItemTableViewCell {
            return cell
         }
         return UITableViewCell()
    }
    
}
