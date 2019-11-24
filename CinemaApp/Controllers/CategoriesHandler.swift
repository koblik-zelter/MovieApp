//
//  CategoriesHandler.swift
//  CinemaApp
//
//  Created by Alex Koblik-Zelter on 11/21/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents

class CategoriesHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: FilterDelegate?
    
    var categories: [Category] = []
    
    func appendCategories(categories: [Category]) {
        self.categories.removeAll()
        self.categories.append(contentsOf: categories)
    }
    //let categories = ["filter", "Drama", "Comedy", "Action", "Fantasy", "Historical", "Horror", "Mystery", "Drama", "Comedy", "Action", "Fantasy", "Historical", "Horror", "Mystery", "Drama", "Comedy", "Action", "Fantasy", "Historical", "Horror", "Mystery"]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as? MDCChipCollectionViewCell else { return UICollectionViewCell() }
        cell.chipView.backgroundColor = .gray
        cell.chipView.titleLabel.textColor = .black
        if indexPath.item == 0 {
            cell.chipView.imageView.image = UIImage(named: "slider")
            //print(categories[indexPath.item].name)
            cell.chipView.imageView.contentMode = .center
            cell.chipView.imagePadding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            return cell
        }
        cell.chipView.titleLabel.text = categories[indexPath.item - 1].name
    //    cell.chipView.titleLabel.text = categories[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: 48, height: 40)
        }
        let label = UILabel()
        label.text = categories[indexPath.item - 1].name
//        label.text = categories[indexPath.item - 1]
        label.sizeToFit()
        let width = label.frame.width + 32
        return CGSize(width: width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("SELECTED")
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        print(indexPath.item)
        self.delegate?.didSelectCategory(categories[indexPath.item - 1])
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.item == 0 {
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
}

extension MDCChipCollectionViewCell {
    open override func prepareForReuse() {
        super.prepareForReuse()
        chipView.imageView.image = nil
        chipView.imagePadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        chipView.titleLabel.text = ""
    }
}
