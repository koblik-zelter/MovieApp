//
//  SearchViewController.swift
//  CinemaApp
//
//  Created by Alex Koblik-Zelter on 11/24/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit

fileprivate let cellID = "cellID"
class SearchViewController: UIViewController {

    var searchController: UISearchController!
    let layout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView!
    
    private var movies: [Movie] = []
    private var currentPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            navBarAppearance.backgroundColor = .white
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            self.navigationItem.title = "Discover Movies"
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    fileprivate func setupSearchBar() {
        self.view.backgroundColor = .white
        self.searchController = UISearchController(searchResultsController:  nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false

        searchController.searchBar.placeholder = "Search Movies"
        self.navigationItem.searchController = searchController
        self.searchController.obscuresBackgroundDuringPresentation = true
        self.searchController.searchBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        definesPresentationContext = true
    }
    
    fileprivate func setupCollectionView() {
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = true
        collectionView.isScrollEnabled = true
        self.view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    fileprivate func searchMovies(_ searchText: String) {
        APIManager.shared.searchMovies(searchText, page: currentPage) { (movies, error)  in
            if let movies = movies {
                self.movies.removeAll()
                let data = movies.filter { $0.path != nil && $0.rating != 0 }
                self.movies.append(contentsOf: data)
                self.currentPage += 1
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            else {
                print(error)
            }
        }
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


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? MovieCell else { return UICollectionViewCell() }
        cell.movie = movies[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailsViewController()
        vc.movie = movies[indexPath.item]
        vc.hidesNavBar = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.currentPage = 1
        self.searchMovies(text.lowercased())
        searchController.isActive = false
        searchBar.text = text
    }
    
    
}
