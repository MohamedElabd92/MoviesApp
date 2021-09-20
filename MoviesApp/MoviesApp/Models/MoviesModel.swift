//
//  MoviesModel.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 20/09/2021.
//

import Foundation

class MoviesModel: Codable {
    var dates: DatesObject?
    var page: Int?
    var results: [ResultsObject]?
    var total_pages: Int?
    var total_results: Int?
}

class DatesObject: Codable {
    var maximum: String?
    var minimum: String?
}

class ResultsObject: Codable {
    var adult: Bool?
    var backdrop_path: String?
    var genre_ids: [Int]?
    var id: Int?
    var original_language: String?
    var original_title: String?
    var overview: String?
    var popularity: Double?
    var poster_path: String?
    var release_date: String?
    var title: String?
    var video: Bool?
    var vote_average: Double?
    var vote_count: Int?
}
