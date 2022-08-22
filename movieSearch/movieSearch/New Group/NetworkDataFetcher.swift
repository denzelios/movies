//
//  NetwordDataFetcher.swift
//  movieSearch
//
//  Created by Андрей Цуркан on 05.08.2022.
//

import Foundation

class NetworkDataFetcher {
   private let networkService = NetworkService()
    
    func fetchMovie(urlString: String, response: @escaping (SearchResponse?) ->Void) {
        networkService.request(urlString: urlString) { result in
            switch result {
            case.success(let data):
                do {
                    let movies = try JSONDecoder().decode(SearchResponse.self, from: data)
                    response(movies)
                } catch let jsonError {
                    print("Failied to Docode", jsonError)
                    response(nil)
                }
            case.failure(let error):
                print("SYSTEM ERROR\(error.localizedDescription)")
                response(nil)
            }
        }
    }
}
