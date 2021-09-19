//
//  TopRatedViewController.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 19/09/2021.
//

import UIKit

class TopRatedViewController: UIViewController {
    @IBOutlet weak var topRatedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialSetup()
    }

    func initialSetup() {
        self.title = "Top Rated"
        
        topRatedTableView.delegate = self
        topRatedTableView.dataSource = self
        
        registerCells()
    }
    
    func registerCells() {
        self.topRatedTableView.register(UINib(nibName: "MovieItemTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieItemTableViewCell")
    }
}

extension TopRatedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = topRatedTableView.dequeueReusableCell(withIdentifier: "MovieItemTableViewCell", for: indexPath) as? MovieItemTableViewCell {
            return cell
         }
         return UITableViewCell()
    }
    
}
