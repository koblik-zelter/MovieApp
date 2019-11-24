//
//  HomeHeader.swift
//  CinemaApp
//
//  Created by Alex Koblik-Zelter on 11/20/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import Foundation

class HomeHeader: UICollectionReusableView {
    
    
    let todayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Today"
        label.textColor = .black
        label.font = .systemFont(ofSize: 32, weight: .init(0.3))
        return label
    }()
    
    let movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "clapper")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        //    iv.image = #imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal)
        button.layer.cornerRadius = 18
        button.backgroundColor = .rgbColor(red: 220, green: 220, blue: 220, alpha: 1)
       // button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(openSearchController), for: .touchUpInside)
        return button
    }()
    
    let popularLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Polular"
        label.textColor = .black
        label.font = .systemFont(ofSize: 26, weight: .init(0.3))
        return label
    }()
    
    let polularImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "videoCamera")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let moviesCollection: UICollectionView = {
        let layout = BetterSnappingLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .white
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        collection.backgroundColor = .init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        collection.decelerationRate = .fast
        return collection
    }()
    
    let categoriesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .white
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        collection.backgroundColor = .init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
       
        return collection
    }()
    
    var delegate: SearchDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        let views = [movieImageView, todayLabel, searchButton, moviesCollection, polularImageView, popularLabel, categoriesCollection]
        views.forEach { (view) in
            self.addSubview(view)
        }
        
        todayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        movieImageView.centerYAnchor.constraint(equalTo: todayLabel.centerYAnchor).isActive = true
        todayLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 12).isActive = true
        movieImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        movieImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        movieImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true

        searchButton.centerYAnchor.constraint(equalTo: todayLabel.centerYAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        moviesCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        moviesCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        moviesCollection.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 0).isActive = true
        
        let width = self.bounds.width * 2 / 3
        let height = width * 1.48
        moviesCollection.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        popularLabel.topAnchor.constraint(equalTo: moviesCollection.bottomAnchor, constant: 0).isActive = true
        polularImageView.centerYAnchor.constraint(equalTo: popularLabel.centerYAnchor).isActive = true
        popularLabel.leadingAnchor.constraint(equalTo: polularImageView.trailingAnchor, constant: 8).isActive = true
        polularImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        polularImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        polularImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        categoriesCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        categoriesCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        categoriesCollection.topAnchor.constraint(equalTo: popularLabel.bottomAnchor, constant: 16).isActive = true
        categoriesCollection.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
//        let stack = UIStackView(arrangedSubviews: [movieImageView, todayLabel])
//        stack.distribution = .fillProportionally
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.spacing = 12
//        stack.axis = .horizontal
//        self.addSubview(stack)
//        stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
//        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
    
        
        
    }
    
    @objc func openSearchController() {
        self.delegate?.didTapOnSearch()
    }
}
