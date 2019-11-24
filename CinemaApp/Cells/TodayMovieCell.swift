//
//  TodayMovieCell.swift
//  CinemaApp
//
//  Created by Alex Koblik-Zelter on 11/21/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import Kingfisher

class TodayMovieCell: UICollectionViewCell {
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            let rating = Int(round((movie.rating ?? 0) * 10))
            ratingView.titleLabel.text = "\(rating)%"
            guard let url = movie.path else {
                return
            }
            let imageRes = ImageResource(downloadURL: URL(string: "https://image.tmdb.org/t/p/w500//\(url)")!)
            movieImageView.kf.setImage(with: imageRes)
            
        }
    }
    let movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "test")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        return iv
    }()
    
    let ratingView: MDCChipView = {
        let view = MDCChipView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = UIImage(named: "heart1")
        view.imagePadding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        view.setBackgroundColor(.init(white: 0.5, alpha: 0.7), for: .normal)
        view.setBackgroundColor(.init(white: 0.5, alpha: 0.7), for: .selected)
        view.setInkColor(.clear, for: .normal)
     //   view.titleLabel.textColor = .white
        view.setTitleColor(.white, for: .normal)
        view.setTitleColor(.white, for: .selected)
       // view.isEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        
        self.addSubview(movieImageView)
        
        movieImageView.addSubview(ratingView)
        movieImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        movieImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        movieImageView.widthAnchor.constraint(equalToConstant: self.bounds.width - 16).isActive = true
        movieImageView.heightAnchor.constraint(equalToConstant: self.bounds.height - 32).isActive = true
        
        ratingView.topAnchor.constraint(equalTo: movieImageView.topAnchor, constant: 16).isActive = true
        ratingView.leadingAnchor.constraint(equalTo: movieImageView.leadingAnchor, constant: 16).isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
    }
    
}
