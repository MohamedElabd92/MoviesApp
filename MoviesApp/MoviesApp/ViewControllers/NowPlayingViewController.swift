//
//  NowPlayingViewController.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 19/09/2021.
//

import UIKit
import ProgressHUD

var configurationModel = ConfigurationModel()

class NowPlayingViewController: UIViewController {
    @IBOutlet weak var nowPlayingTableView: UITableView!
    
    let moviesViewModel = MoviesViewModel()
    var results = [ResultsObject]()
    var pageNumber = 1
    var isLoadingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nowPlayingTableView.reloadData()
    }

    func initialSetup() {
        self.title = "Now Playing"
        
        nowPlayingTableView.delegate = self
        nowPlayingTableView.dataSource = self
        
        registerCells()
        getData()
    }
    
    func registerCells() {
        self.nowPlayingTableView.register(UINib(nibName: "MovieItemTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieItemTableViewCell")
    }
    
    func getData() {
        ProgressHUD.show()
        moviesViewModel.nowPlayingDelegate = self
        moviesViewModel.errorDelegate = self
        moviesViewModel.configurationDelegate = self
        moviesViewModel.getConfig()
    }
    
    func showLoadMoreSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
}

extension NowPlayingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = nowPlayingTableView.dequeueReusableCell(withIdentifier: "MovieItemTableViewCell", for: indexPath) as? MovieItemTableViewCell {
            cell.setData(model: results[indexPath.row])
            return cell
         }
         return UITableViewCell()
    }
}

extension NowPlayingViewController: NowPlayingDelegate {
    func getNowPlayingResponse(model: MoviesModel) {
        ProgressHUD.dismiss()
        results.append(contentsOf: model.results ?? [])
        
        nowPlayingTableView.reloadData()
        nowPlayingTableView.tableFooterView = nil
        isLoadingMore = false
    }
}

extension NowPlayingViewController: ErrorDelegate {
    func showErrorMessage(message: String) {
        ProgressHUD.dismiss()
        showAlert(title: "", message: message)
    }
}

extension NowPlayingViewController: ConfigurationDelegate {
    func getConfigurationResponse(model: ConfigurationModel) {
        configurationModel = model
        
        moviesViewModel.getNowPlayingList(pageNumber: pageNumber)
    }
}

extension NowPlayingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isLoadingMore && !results.isEmpty {
            let scrollViewOffset = scrollView.contentOffset.y
            let location = nowPlayingTableView.contentSize.height - scrollView.frame.size.height - 100

            if scrollViewOffset > location {
                isLoadingMore = true
                nowPlayingTableView.tableFooterView = showLoadMoreSpinner()
                
                pageNumber += 1
                moviesViewModel.getNowPlayingList(pageNumber: pageNumber)
            }
        }
    }
}
