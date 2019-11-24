//
//  MovieDetailsViewController.swift
//  CinemaApp
//
//  Created by Alex Koblik-Zelter on 11/24/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import MaterialComponents
import Kingfisher
import FloatingPanel

class MovieDetailsViewController: UIViewController {
    let scrollView = UIScrollView()
    var hidesNavBar: Bool = false
    let fpc = FloatingPanelController()
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "joker")
        iv.layer.cornerRadius = 16
        return iv
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "goback"), for: .normal)
        button.layer.cornerRadius = 18
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        button.layer.cornerRadius = 18
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        fpc.dismiss(animated: false)
      //  self.navigationController?.isNavigationBarHidden = hidesNavBar
    }
    
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            guard let url = movie.path else {
                return
            }
            let imageRes = ImageResource(downloadURL: URL(string: "https://image.tmdb.org/t/p/w500//\(url)")!)
            movieImageView.kf.setImage(with: imageRes)
            backgroundImageView.kf.setImage(with: imageRes)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
            //.rgbColor(red: 163, green: 217, blue: 202, alpha: 1)
        self.setupViews()
        let contentVC = MovieHelperViewController()
        contentVC.movie = self.movie
        contentVC.modalPresentationStyle = .overCurrentContext
        fpc.set(contentViewController: contentVC)
        fpc.isRemovalInteractionEnabled = false // Optional: Let it removable by a swipe-down
        self.present(fpc, animated: true, completion: nil)
    //    self.setupContentView()
        
    }
    
    fileprivate func setupViews() {
        self.view.addSubview(backgroundImageView)
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.addBlurEffect()
        self.view.addSubview(backButton)
        self.view.addSubview(likeButton)
        backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        likeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -32).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        self.view.addSubview(movieImageView)
        movieImageView.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 16).isActive = true
        movieImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32).isActive = true
        let width = self.view.bounds.width - 64
        let height = width * 1.48 - 32
        movieImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        movieImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }

}
