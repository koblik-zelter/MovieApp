//
//  MovieHelperViewController.swift
//  CinemaApp
//
//  Created by Alex Koblik-Zelter on 11/25/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import MaterialComponents
import Kingfisher

class MovieHelperViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Joker"
        label.font = .systemFont(ofSize: 24, weight: .init(0.3))
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2019"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
        view.setTitleColor(.white, for: .normal)
        view.setTitleColor(.white, for: .selected)
        view.titleLabel.text = "92%"
        return view
    }()
    
    let reviewButton: MDCChipView = {
        let view = MDCChipView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.image = #imageLiteral(resourceName: "chat")
        view.imagePadding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        view.setBackgroundColor(.white, for: .normal)
        view.setBackgroundColor(.white, for: .selected)
        view.setBorderColor(.rgbColor(red: 90, green: 70, blue: 221, alpha: 1), for: .normal)
        view.setBorderColor(.rgbColor(red: 90, green: 70, blue: 221, alpha: 1), for: .selected)
        view.setBorderWidth(1, for: .normal)
        view.setBorderWidth(1, for: .selected)
       // view.setInkColor(.clear, for: .normal)
        //   view.titleLabel.textColor = .white
        view.setTitleColor(.rgbColor(red: 90, green: 70, blue: 221, alpha: 1), for: .normal)
        view.setTitleColor(.rgbColor(red: 90, green: 70, blue: 221, alpha: 1), for: .selected)
        view.titleLabel.text = "Review"
        
        view.semanticContentAttribute = .forceRightToLeft
            // view.isEnabled = false
        return view
    }()
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            let rating = Int(round((movie.rating ?? 0) * 10))
            ratingView.titleLabel.text = "\(rating)%"
            titleLabel.text = movie.title
            yearLabel.text = String(movie.date.prefix(4))
            descriptionLabel.text = movie.overview
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupContentView()
        // Do any additional setup after loading the view.
    }
    
    
    fileprivate func setupContentView() {
        let views = [titleLabel, ratingView, yearLabel, descriptionLabel, reviewButton]
        views.forEach { (view) in
            self.view.addSubview(view)
        }
        
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32).isActive = true
        
        ratingView.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor).isActive = true
        ratingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -32).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: -32).isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 76).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        yearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor).isActive = true
        reviewButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16).isActive = true
        reviewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reviewButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        reviewButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
