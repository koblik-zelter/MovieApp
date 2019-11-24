//
//  RatingView.swift
//  CinemaApp
//
//  Created by Alex Koblik-Zelter on 11/21/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import UIKit

class RatingView: UIView {
    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .rgbColor(red: 194, green: 194, blue: 194, alpha: 0.5)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
       
    let heartImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "heart1")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
       
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " 92%"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .init(0.2))
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        self.addSubview(view)
//        view.topAnchor.constraint(equalTo: movieImageView.topAnchor, constant: 16).isActive = true
//        view.leadingAnchor.constraint(equalTo: movieImageView.leadingAnchor, constant: 16).isActive = true
        view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [heartImageView, ratingLabel])
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
