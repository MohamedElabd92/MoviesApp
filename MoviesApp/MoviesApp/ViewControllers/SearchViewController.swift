//
//  SearchViewController.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 19/09/2021.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialSetup()
    }

    func initialSetup() {
        self.title = "Search"
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        registerCells()
    }
    
    func registerCells() {
        self.searchTableView.register(UINib(nibName: "MovieItemTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieItemTableViewCell")
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = searchTableView.dequeueReusableCell(withIdentifier: "MovieItemTableViewCell", for: indexPath) as? MovieItemTableViewCell {
            return cell
         }
         return UITableViewCell()
    }
    
}
