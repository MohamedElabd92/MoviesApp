//
//  SearchViewController.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 19/09/2021.
//

import UIKit
import ProgressHUD

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var emptyStateConteinerView: UIView!
    @IBOutlet weak var emptyStateTitle: UILabel!
    @IBOutlet weak var emptyStateSubtitle: UILabel!
    @IBOutlet weak var imageVerticalConstraint: NSLayoutConstraint!
    
    let searchBar = UISearchController()
    var searchText = ""
    
    let moviesViewModel = MoviesViewModel()
    var results = [ResultsObject]()
    var pageNumber = 1
    var isLoadingMore = false
    
    var searchTask: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTableView.reloadData()
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
        self.title = "Search"
        
        setupSearchBar()
        setupTableView()
        setupViewModel()
        
        if results.isEmpty {
            searchTableView.isHidden = true
            emptyStateConteinerView.isHidden = false
            
            emptyStateTitle.text = "Search for movies"
            emptyStateSubtitle.text = "Please enter movie name in search above"
        } else {
            searchTableView.isHidden = false
            searchTableView.reloadData()
            emptyStateConteinerView.isHidden = true
        }
    }
    
    func setupSearchBar() {
        searchBar.searchResultsUpdater = self
        navigationItem.searchController = searchBar
    }
    
    func registerCells() {
        self.searchTableView.register(UINib(nibName: "MovieItemTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieItemTableViewCell")
    }
    
    func setupTableView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        registerCells()
    }
    
    func setupViewModel() {
        moviesViewModel.searchListDelegate = self
        moviesViewModel.errorDelegate = self
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = searchTableView.dequeueReusableCell(withIdentifier: "MovieItemTableViewCell", for: indexPath) as? MovieItemTableViewCell {
            cell.setData(model: results[indexPath.row])
            return cell
         }
         return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
            vc.result = results[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        
        self.searchText = text
        self.searchTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            self?.pageNumber = 1
            self?.isLoadingMore = false
            self?.results = []
            
            ProgressHUD.show()
            self?.moviesViewModel.getSearchList(pageNumber: self?.pageNumber ?? 1, searchText: text)
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
}

extension SearchViewController: SearchListDelegate {
    func getSearchListResponse(model: MoviesModel) {
        ProgressHUD.dismiss()
        results.append(contentsOf: model.results ?? [])
        
        if results.isEmpty {
            searchTableView.isHidden = true
            emptyStateConteinerView.isHidden = false
            
            emptyStateTitle.text = "No Results found!"
            emptyStateSubtitle.text = "Please try again"
        } else {
            searchTableView.isHidden = false
            searchTableView.reloadData()
            emptyStateConteinerView.isHidden = true
        }
        
        searchTableView.tableFooterView = nil
        isLoadingMore = false
    }
}

extension SearchViewController: ErrorDelegate {
    func showErrorMessage(message: String) {
        ProgressHUD.dismiss()
        showAlert(title: "", message: message)
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isLoadingMore && !results.isEmpty {
            let scrollViewOffset = scrollView.contentOffset.y
            let location = searchTableView.contentSize.height - scrollView.frame.size.height - 100
            
            if scrollViewOffset > location {
                isLoadingMore = true
                searchTableView.tableFooterView = showLoadMoreSpinner()
                
                if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    pageNumber += 1
                    moviesViewModel.getSearchList(pageNumber: self.pageNumber, searchText: searchText)
                }
            }
        }
    }
}
