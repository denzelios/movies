//
//  SearchResponse.swift
//  movieSearch
//
//  Created by Андрей Цуркан on 05.08.2022.
//

import Foundation

struct SearchResponse: Codable {
    var movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
    }
}

struct Movie: Codable {
    var title: String?
    var year: String?
    var poster: String?
    enum CodingKeys: String, CodingKey {
        
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
    }
}
