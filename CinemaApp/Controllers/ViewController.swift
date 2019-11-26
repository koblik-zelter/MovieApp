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
    
    let layout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView!
    
    let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.translatesAutoresizingMaskIntoConstraints = false
        rc.tintColor = .rgbColor(red: 90, green: 70, blue: 221, alpha: 1)
        return rc
    }()
    
    
    private let todayHandler = TodayHandler()
    private let categoriesHandler = CategoriesHandler()
    private var movies: [Movie] = []
    private var categories: [Category] = []
    private var currentType: CurrentType = .bestMoovies
    private var currentCategory: Category?
    private var currentSortType: SortType = .popularityDesc
    private let group = DispatchGroup()
    private var page = 1 // For pagination
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupViews()
        self.getCategories()
        self.fetchDataByType()
        self.fetchTodayMovies()
        self.updateView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    fileprivate func setupViews() {
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
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
    }
    
    fileprivate func fetchMovies(page: Int) {
        self.group.enter()
        APIManager.shared.discoverBestMovies(page: page) { (movies, error) in
            if let movies = movies {
                let data = movies.filter { $0.path != nil && $0.rating != 0 }
                self.movies.append(contentsOf: data)
                self.todayHandler.appendMovies(movies: self.movies)
                self.page += 1
            }
            else {
                print(error)
            }
            self.group.leave()
        }
    }
    
    fileprivate func updateView() {
        group.notify(queue: .main, execute: {
            guard let header = self.getCollectionHeader() else { return }
            header.moviesCollection.reloadData()
            header.categoriesCollection.reloadData()
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.refreshControl?.endRefreshing()
        })
    }
    
    fileprivate func fetchMovieByCategory(category: Category, page: Int) {
        self.currentCategory = category
        APIManager.shared.discoverMoviesByCategory(page: page, category: category) { (movies, error)  in
            if let movies = movies {
                self.currentType = .byCategories
                self.movies.removeAll()
                let data = movies.filter { $0.path != nil && $0.rating != 0 }
                self.movies.append(contentsOf: data)
                self.page += 1
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            else {
                print(error)
            }
        }
    }
    
    fileprivate func getCategories() {
        self.group.enter()
        APIManager.shared.getGenres { (categories, error) in
            if let categories = categories {
                self.categories.removeAll()
                self.categories.append(contentsOf: categories)
                self.categoriesHandler.appendCategories(categories: self.categories)
            }
            else {
                print(error)
            }
            self.group.leave()
        }
    }
    
    fileprivate func fetchTodayMovies() {
        self.group.enter()
        APIManager.shared.discoverBestMovies(page: 1) { (movies, error) in
            if let movies = movies {
                self.todayHandler.appendMovies(movies: movies)
            }
            else {
                print(error)
            }
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
            categoriesHandler.sortDelegate = self
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

extension ViewController: SortProtocol {
    func changeSortType() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let popAsc = UIAlertAction(title: "Popularity Asc", style: .default)
        
        let popDesc = UIAlertAction(title: "Popularity Desc", style: .default)
        
        let ratAsc = UIAlertAction(title: "Rating Asc", style: .default)
        
        let ratDesc = UIAlertAction(title: "Rating Desc", style: .default)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let actions = [popDesc, popAsc, ratDesc, ratAsc, cancelAction]
        actions.forEach { (action) in
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true)
    }
}
enum CurrentType: String {
    case bestMoovies = "moovie"
    case byCategories = "categories"
}
