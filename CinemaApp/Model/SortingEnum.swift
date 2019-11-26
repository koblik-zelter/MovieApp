//
//  SortingEnum.swift
//  CinemaApp
//
//  Created by Alex Koblik-Zelter on 11/25/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation

enum SortType: String {
    case ratingAsc = "vote_average.desc"
    case ratingDesc = "vote_average.asc"
    case popularityAsc = "popularity.asc"
    case popularityDesc = "popularity.desc"
}
