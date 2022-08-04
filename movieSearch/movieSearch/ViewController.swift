//
//  ViewController.swift
//  movieSearch
//
//  Created by Андрей Цуркан on 04.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    var tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange

        setupTableView()
        setupSearchBar()
        
    }
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false

}

    
    
}

private func setupTableView(){
//    table.delegate = self
//    table.dataSource = self
//    table.register(UITableViewCell)
    
}

extension ViewController: UISearchBarDelegate {
    func serchBar(_ searchBAr: UISearchBar, textDidChange searchText: String) {
        
    }
}
