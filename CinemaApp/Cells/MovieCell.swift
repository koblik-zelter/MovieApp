//
//  MovieCell.swift
//  CinemaApp
//
//  Created by Alex Koblik-Zelter on 11/21/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import MaterialComponents

class MovieCell: UICollectionViewCell {
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            titleLabel.text = movie.title
            let rating = Int(round((movie.rating ?? 0) * 10))
            self.isTop = rating >= 70
           // ratingView.ratingLabel.text = " \(rating)%"
            ratingView.titleLabel.text = "\(rating)%"
        }
    }
    
    var isTop: Bool? {
        didSet {
            guard let isTop = isTop else { return }
            if isTop {
                self.backgroundColor = .rgbColor(red: 90, green: 70, blue: 221, alpha: 1)
                self.ratingView.setBackgroundColor(.init(white: 1, alpha: 0.3), for: .normal)
                self.titleLabel.textColor = .white
                self.ratingView.titleLabel.textColor = .white
            }
            else {
                self.backgroundColor = .rgbColor(red: 235, green: 235, blue: 235, alpha: 1)
                self.titleLabel.textColor = .black
               // self.ratingView.titleLabel.textColor = .black
                self.ratingView.setBackgroundColor(.rgbColor(red: 194, green: 194, blue: 194, alpha: 1), for: .normal)
            }
        }
    }
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Joker"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
      //  label.textAlignment = .center
        return label
    }()
    
    
    let ratingView: MDCChipView = {
        let view = MDCChipView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = UIImage(named: "heart1")
        view.imagePadding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        view.setBackgroundColor(.rgbColor(red: 194, green: 194, blue: 194, alpha: 1), for: .normal)
        view.setBackgroundColor(.rgbColor(red: 194, green: 194, blue: 194, alpha: 1), for: .selected)
        view.setInkColor(.clear, for: .normal)
     //   view.titleLabel.textColor = .white
        view.setTitleColor(.white, for: .normal)
        view.setTitleColor(.white, for: .selected)
       // view.isEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackground()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupBackground() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .rgbColor(red: 235, green: 235, blue: 235, alpha: 1)
        self.clipsToBounds = true
    }
    private func setupViews() {
        let views = [titleLabel, ratingView]
        views.forEach { (view) in
            self.addSubview(view)
        }
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32).isActive = true
        
        ratingView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ratingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: -32).isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 76).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        sizeToFit()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.isTop = false
    }
    
}
