//
//  PosterCell.swift
//  movieSearch
//
//  Created by Андрей Цуркан on 10.08.2022.
//

import UIKit

class PosterCell: UICollectionViewCell {
    
    
    var lable = UILabel()
    static let reuseId = "PosterCell"
    var searchResponse:SearchResponse? = nil

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
    
    var posterImage: Movie!{
        didSet{
            let posterUrl = posterImage.poster
        }
    }
    
    var url: URL? {
        didSet{
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
        
        lable.textAlignment = .center
        lable.textColor = .black
        lable.backgroundColor = .white
        lable.font = UIFont.systemFont(ofSize: 18)
        lable.numberOfLines = 0
    
    }
    
    private func setupPosterImageview() {
        addSubview(posterImageView)
        addSubview(lable)
        lable.translatesAutoresizingMaskIntoConstraints = false
        [posterImageView.topAnchor.constraint(equalTo: topAnchor),
         posterImageView.leftAnchor.constraint(equalTo: leftAnchor),
         posterImageView.rightAnchor.constraint(equalTo: rightAnchor),
         posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40)] .forEach {$0.isActive = true}
        
        [lable.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10),
         lable.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
         lable.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
         lable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)].forEach { $0.isActive = true}
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func downloadPoster() {
        guard let url = url else {
            return
        }
        
        NetworkService().request(urlString: url.absoluteString) { [weak self] result in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self?.posterImageView.image = UIImage(data: data)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}




