//
//  Model.swift
//  CinemaApp
//
//  Created by Alex Koblik-Zelter on 11/22/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation

struct Result: Decodable {
    var page: Int
    var results: [Movie]
}
struct Movie: Decodable {
    var path: String?
    var title: String
    var rating: Double?
    var overview: String
    var date: String
    
    enum CodingKeys: String, CodingKey {
        case path = "poster_path"
        case title = "title"
        case rating = "vote_average"
        case overview = "overview"
        case date = "release_date"
    }
}

struct Test: Decodable {
    let genres: [Category]
}
struct Category: Decodable {
    let id: Int
    let name: String
}
