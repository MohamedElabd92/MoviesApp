//
//  TopRatedViewController.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 19/09/2021.
//

import UIKit
import ProgressHUD

class TopRatedViewController: UIViewController {
    @IBOutlet weak var topRatedTableView: UITableView!
    
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
        topRatedTableView.reloadData()
    }

    func initialSetup() {
        self.title = "Top Rated"
        
        topRatedTableView.delegate = self
        topRatedTableView.dataSource = self
        
        registerCells()
        getData()
    }
    
    func registerCells() {
        self.topRatedTableView.register(UINib(nibName: "MovieItemTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieItemTableViewCell")
    }
    
    func getData() {
        ProgressHUD.show()
        moviesViewModel.topRatedDelegate = self
        moviesViewModel.errorDelegate = self
        moviesViewModel.getTopRatedList(pageNumber: pageNumber)
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

extension TopRatedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = topRatedTableView.dequeueReusableCell(withIdentifier: "MovieItemTableViewCell", for: indexPath) as? MovieItemTableViewCell {
            cell.setData(model: results[indexPath.row])
            return cell
         }
         return UITableViewCell()
    }
    
}

extension TopRatedViewController: TopRatedDelegate {
    func getTopRatedResponse(model: MoviesModel) {
        ProgressHUD.dismiss()
        results.append(contentsOf: model.results ?? [])
        
        topRatedTableView.reloadData()
        topRatedTableView.tableFooterView = nil
        isLoadingMore = false
    }
}

extension TopRatedViewController: ErrorDelegate {
    func showErrorMessage(message: String) {
        ProgressHUD.dismiss()
        showAlert(title: "", message: message)
    }
}

extension TopRatedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isLoadingMore && !results.isEmpty {
            let scrollViewOffset = scrollView.contentOffset.y
            let location = topRatedTableView.contentSize.height - scrollView.frame.size.height - 100

            if scrollViewOffset > location {
                isLoadingMore = true
                topRatedTableView.tableFooterView = showLoadMoreSpinner()
                
                pageNumber += 1
                moviesViewModel.getTopRatedList(pageNumber: pageNumber)
            }
        }
    }
}
