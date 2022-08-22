//
//  PosterCell.swift
//  movieSearch
//
//  Created by Андрей Цуркан on 10.08.2022.
//

import UIKit

class PosterCell: UICollectionViewCell {
    
    var label = UILabel()
    static let reuseId = "PosterCell"
    var searchResponse: SearchResponse? = nil

    override var reuseIdentifier: String? {
        PosterCell.reuseId
    }
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var url: URL? {
        didSet {
            downloadPoster()
        }
    }
    
    override var isSelected: Bool{
        didSet{
            upDateSelectedState()
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    private func upDateSelectedState(){
        posterImageView.alpha = isSelected ? 0.7 : 1
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        upDateSelectedState()
        setupPosterImageview()
        
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPosterImageview() {
        addSubview(posterImageView)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        posterImageView.topAnchor.constraint(equalTo: topAnchor),
         posterImageView.leftAnchor.constraint(equalTo: leftAnchor),
         posterImageView.rightAnchor.constraint(equalTo: rightAnchor),
         posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40)])
        
    NSLayoutConstraint.activate([
        label.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10),
         label.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
         label.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
         label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)])
    }
    
    func downloadPoster() {
        guard let url = url else {
            return
        }
        
        NetworkService().request(urlString: url.absoluteString) { [weak self] result in
            switch result {
            case let .success(data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.posterImageView.image = image
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}
