//
//  NowPlayingViewController.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 19/09/2021.
//

import UIKit

class NowPlayingViewController: UIViewController {
    @IBOutlet weak var nowPlayingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialSetup()
    }

    func initialSetup() {
        self.title = "Now Playing"
        
        nowPlayingTableView.delegate = self
        nowPlayingTableView.dataSource = self
        
        registerCells()
    }
    
    func registerCells() {
        self.nowPlayingTableView.register(UINib(nibName: "MovieItemTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieItemTableViewCell")
    }
}

extension NowPlayingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = nowPlayingTableView.dequeueReusableCell(withIdentifier: "MovieItemTableViewCell", for: indexPath) as? MovieItemTableViewCell {
            return cell
         }
         return UITableViewCell()
    }
    
}
