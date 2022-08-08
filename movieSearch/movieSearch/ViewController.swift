//
//  ViewController.swift
//  movieSearch
//
//  Created by Андрей Цуркан on 04.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let networkDataFetcher = NetwordDataFetcher()
    var tableView = UITableView()
    var searchResponse:SearchResponse? = nil
    let searchController = UISearchController(searchResultsController: nil)
    let lbl = UILabel()
    var timer: Timer? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupSearchBar()
        title = "Search"
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.backgroundColor = .white
        lbl.font = UIFont.systemFont(ofSize: 26)
        lbl.text = "Вы пока ничего\n не ввели"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        view.addSubview(lbl)
        view.addSubview(tableView)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        [lbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 400),
         lbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 1),
         lbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 1),
         lbl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -350),
         lbl.heightAnchor.constraint(equalToConstant: 120)].forEach { $0.isActive = true }
        
        [tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
         tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)].forEach { $0.isActive = true }
        
    }
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func loadData(text: String){
        let urlString = "https://www.omdbapi.com/?s=\(text)&apikey=9221815c"
        
        networkDataFetcher.fetchMovie(urlString: urlString) { [weak self]searchResponse in
            guard let searchResponse = searchResponse else { return }
            self?.searchResponse = searchResponse
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection sectin: Int) -> Int{
        return searchResponse?.movies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let movie = searchResponse?.movies[indexPath.row]
        print("movie?.poster",movie?.poster)
        cell.textLabel?.text = movie?.title
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBAr: UISearchBar, textDidChange searchText: String){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.loadData(text: searchText)
        })
        return
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchResponse = nil
//        tableView.reloadData()
        
    }
}



