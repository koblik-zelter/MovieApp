//
//  ViewController.swift
//  CinemaApp
//
//  Created by Alex Koblik-Zelter on 11/20/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import MaterialComponents

fileprivate let cellId = "id"
fileprivate let headerId = "headerId"
let todayMovieCellId = "todayMovieCellId"
let categoryCellId = "categoryCellId"
class ViewController: UIViewController {
    
    let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.translatesAutoresizingMaskIntoConstraints = false
        rc.tintColor = .rgbColor(red: 90, green: 70, blue: 221, alpha: 1)
        return rc
    }()
    
    let layout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView!
    var searchController: UISearchController!
    let todayHandler = TodayHandler()
    let categoriesHandler = CategoriesHandler()
    var movies: [Movie] = []
    var categories: [Category] = []
    private var currentType: CurrentType = .bestMoovies
    private var currentCategory: Category?
    private let group = DispatchGroup()
    private var page = 1 // For pagination
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupViews()
        self.setupSearchView()
        self.getCategories()
        self.fetchDataByType()
        self.fetchTodayMovies()
        self.updateView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     /*   if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            navBarAppearance.backgroundColor = .white
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            self.navigationItem.title = "Cinema App"
            //self.navigationController?.navigationBar.prefersLargeTitles = true
        }
 */
 
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    private func setupViews() {
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
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HomeHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    }
    
    private func setupSearchView() {
        self.searchController = UISearchController(searchResultsController:  nil)
        //searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
       // navigationItem.searchController = searchController
        self.searchController.obscuresBackgroundDuringPresentation = true
        self.searchController.searchBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        definesPresentationContext = true
      //  searchController.hidesNavigationBarDuringPresentation = false
    }
    
    private func fetchMovies(page: Int) {
        self.group.enter()
        APIManager.shared.discoverBestMovies(page: page) { (movies) in
            self.movies.append(contentsOf: movies)
            self.todayHandler.appendMovies(movies: self.movies)
            self.page += 1
            self.group.leave()
        }
    }
    
    private func updateView() {
        group.notify(queue: .main, execute: {
            let header = self.getCollectionHeader()
            header?.moviesCollection.reloadData()
            header?.categoriesCollection.reloadData()
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.refreshControl?.endRefreshing()
        })
    }
    
    fileprivate func fetchMovieByCategory(category: Category, page: Int) {
        self.currentCategory = category
        APIManager.shared.discoverMoviesByCategory(page: page, category: category) { (movies) in
            self.currentType = .byCategories
            self.movies.removeAll()
            self.movies.append(contentsOf: movies)
            self.page += 1
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func getCategories() {
        self.group.enter()
        APIManager.shared.getGenres { (categories) in
            self.categories.removeAll()
            self.categories.append(contentsOf: categories)
            self.categoriesHandler.appendCategories(categories: self.categories)
            self.group.leave()
        }
    }
    
    fileprivate func fetchTodayMovies() {
        self.group.enter()
        APIManager.shared.discoverBestMovies(page: 1) { (movies) in
            self.todayHandler.appendMovies(movies: movies)
            self.group.leave()
        }
    }
    
    fileprivate func fetchDataByType() {
        switch self.currentType {
        case .bestMoovies:
            self.fetchMovies(page: page)
        case .byCategories:
            self.fetchMovieByCategory(category: currentCategory!, page: page)
        }
    }
    
    @objc func reloadData() {
        self.page = 1
        self.fetchTodayMovies()
        self.getCategories()
        self.fetchDataByType()
        self.updateView()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MovieCell else { return UICollectionViewCell() }
        cell.movie = movies[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailsViewController()
        vc.movie = movies[indexPath.item]
       // self.present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = UICollectionReusableView()
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? HomeHeader else { return UICollectionReusableView() }
            header.delegate = self
            header.moviesCollection.register(TodayMovieCell.self, forCellWithReuseIdentifier: todayMovieCellId)
            header.moviesCollection.delegate = todayHandler
            header.moviesCollection.dataSource = todayHandler
            
            header.categoriesCollection.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCellId")
            categoriesHandler.delegate = self
            header.categoriesCollection.delegate = categoriesHandler
            header.categoriesCollection.dataSource = categoriesHandler
            return header
        default:
            assert(false, "Unexpected element kind")
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = self.view.bounds.width * 2 / 3
        let height = width * 1.48 + 160
        print(height)
        return CGSize(width: self.collectionView.bounds.width, height: height)
    }
    
    private func getCollectionHeader() -> HomeHeader? {
        return self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0)) as? HomeHeader
    }
}

extension ViewController: FilterDelegate {
    func didSelectCategory(_ category: Category) {
        self.page = 1
        self.fetchMovieByCategory(category: category, page: self.page)
    }
}

extension ViewController: SearchDelegate {
    func didTapOnSearch() {
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

enum CurrentType: String {
    case bestMoovies = "moovie"
    case byCategories = "categories"
}
