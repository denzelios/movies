//
//  ViewController.swift
//  movieSearch
//
//  Created by Андрей Цуркан on 04.08.2022.
//

import UIKit

class InitialWindow: UIViewController {
    
   private var collectionView: UICollectionView! = nil
    private  let networkDataFetcher = NetworkDataFetcher()
    private var searchResponse:SearchResponse? = nil
    private let searchController = UISearchController(searchResultsController: nil)
    private let lbl = UILabel()
    private var timer: Timer? = nil
    
    private var poster = [Movie]()
    
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
        view.addSubview(collectionView)
        view.addSubview(lbl)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
         lbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 400),
         lbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 1),
         lbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 1),
         lbl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -350),
         lbl.heightAnchor.constraint(equalToConstant: 120)])
        
        NSLayoutConstraint.activate([
         collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 40),
         collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
         collectionView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -25),
         collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func loadData(text: String){
        let urlString = "https://www.omdbapi.com/?s=\(text)&apikey=9221815c"
        
        networkDataFetcher.fetchMovie(urlString: urlString) { [weak self] searchResponse in
            guard let searchResponse = searchResponse else { return }
            self?.searchResponse = searchResponse
            self?.collectionView.reloadData()
        }
    }
    
    private func setupTableView(){
        collectionView =  UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.register(PosterCell.self, forCellWithReuseIdentifier: PosterCell.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension InitialWindow: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.reuseId, for: indexPath) as? PosterCell else {
            return UICollectionViewCell()
        }
        
        let movie = searchResponse?.movies[indexPath.item]
        let poster = movie?.poster
        var movieUrl: URL?
        if let nonOptionalMovie = poster {
            movieUrl = URL(string: nonOptionalMovie)
        }
        
        cell.backgroundColor = .white
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 15
        lbl.isHidden = true
        cell.url = movieUrl
        let title = movie?.title
        cell.label.text = title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedView = DetailedViewController()
        let movie = searchResponse?.movies[indexPath.item]
        detailedView.movie = movie
        self.navigationController?.pushViewController(detailedView, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection sectin: Int) -> Int{
        return searchResponse?.movies.count ?? 0
    }
}

extension InitialWindow: UISearchBarDelegate {
    func searchBar(_ searchBAr: UISearchBar, textDidChange searchText: String){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.loadData(text: searchText)
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResponse = nil
        collectionView.reloadData()
        lbl.isHidden = false
    }
}

extension InitialWindow: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.width
        let itemWidth = (screenWidth - 16) / 2
        return CGSize.init(width: itemWidth, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}
