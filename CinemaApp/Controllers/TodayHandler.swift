//
//  TodayHandler.swift
//  CinemaApp
//
//  Created by Alex Koblik-Zelter on 11/20/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import UIKit
class TodayHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var movies: [Movie] = []
    
    func appendMovies(movies: [Movie]) {
        self.movies.removeAll()
        self.movies.append(contentsOf: movies)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: todayMovieCellId, for: indexPath) as? TodayMovieCell else { return UICollectionViewCell() }
        cell.movie = movies[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 2 / 3
        let height = width * 1.48
        return CGSize(width: width, height: height)
    }

    
}
