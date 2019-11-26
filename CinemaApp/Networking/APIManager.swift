//
//  APIManager.swift
//  CinemaApp
//
//  Created by Alex Koblik-Zelter on 11/22/19.
//  Copyright © 2019 Alex Koblik-Zelter. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    static let shared = APIManager()
    private let url = "https://api.themoviedb.org/3/"
    
    // TO DO ENUM FOR SORTING RESULTS
    
    func discoverBestMovies(page: Int, handler: @escaping([Movie]?, Error?) -> Void) {
        let parameters: Parameters = ["api_key": getApiKey(), "sort_by": "popularity.desc", "iclude_adult": false, "include_video": false, "page": page, "language": "en-US", "primary_release_year": 2019]

        Alamofire.request("\(url)discover/movie?", method: .get, parameters: parameters).responseJSON { (response) in
            print(response)
            do {
                if let data = response.data {
                    let result = try JSONDecoder().decode(Result.self, from: data)
                    let movies = result.results
                    handler(movies, nil)
                }
            }
            catch {
                handler(nil, error)
                print("Fail to load best movies")
            }
            
        }
    }
    
    func discoverMoviesByCategory(page: Int, category: Category, handler: @escaping([Movie]?, Error?) -> Void) {
        let parameters: Parameters = ["api_key": getApiKey(), "sort_by": "popularity.desc", "iclude_adult": false, "include_video": false, "page": page, "language": "en-US", "primary_release_year": 2019, "with_genres": category.id]
        Alamofire.request("\(url)discover/movie?", method: .get, parameters: parameters).responseJSON { (response) in
            print(response)
            do {
                if let data = response.data {
                    let result = try JSONDecoder().decode(Result.self, from: data)
                    let movies = result.results
                    handler(movies, nil)
                }
            }
            catch {
                handler(nil, error)
                print("Fail")
            }
        }
    }
    
    func getGenres(handler: @escaping([Category]?, Error?) -> Void) {
        let parameters: Parameters = ["api_key": getApiKey(), "language": "en-US"]
        Alamofire.request("\(url)genre/movie/list?", method: .get, parameters: parameters).responseJSON { (response) in
            print(response)
            if let data = response.data {
                do {
                    let categories = try JSONDecoder().decode(Test.self, from: data)
                    handler(categories.genres, nil)
                }
                catch {
                    handler(nil, error)
                    print("FAIL TO GET GENRES")
                }
            }
        }
    }
    
    func searchMovies(_ query: String, page: Int, handler: @escaping([Movie]?, Error?) -> Void) {
        let parameters: Parameters = ["api_key": getApiKey(), "language": "en_US", "query": query, "page": page, "include_adult": false]
        
        Alamofire.request("\(url)search/movie?", method: .get, parameters: parameters).responseJSON { (response) in
            print(response)
            do {
                if let data = response.data {
                    let result = try JSONDecoder().decode(Result.self, from: data)
                    let movies = result.results
                    handler(movies, nil)
                }
            }
            catch {
                handler(nil, error)
                print("Fail")
            }
        }
    }
    
    private func getApiKey() -> String {
        return "d986890114170e67861f2911dd10257f"
    }
}
