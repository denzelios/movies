//
//  detailedView.swift
//  movieSearch
//
//  Created by Андрей Цуркан on 12.08.2022.
//

import UIKit

class DetailedView: UIViewController {
    
    let yearLabel = UILabel()
    let titleLabel = UILabel()
    let imageView = UIImageView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var movie: Movie? {
        didSet {
            update()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        contentView.backgroundColor = .white
        scrollView.backgroundColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 26)
        titleLabel.numberOfLines = 0
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        yearLabel.textAlignment = .center
        yearLabel.font = UIFont.systemFont(ofSize: 24)
        yearLabel.numberOfLines = 0
    }
    
    private func setupView() {
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(yearLabel)
        
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 5),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            imageView.heightAnchor.constraint(equalToConstant: 500)])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 70)])
        
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            yearLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            yearLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            yearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -200)])
    }
    
    private func update() {
        guard let movie = movie else {
            return
        }
        
        if let urlString = movie.poster {
            NetworkService().request(urlString: urlString) { [weak self] result in
                switch result {
                case let .success(data):
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                case .failure:
                    print("ERROR")
                }
            }
        }
        titleLabel.text = movie.title
        yearLabel.text =  movie.year
    }
    
}
