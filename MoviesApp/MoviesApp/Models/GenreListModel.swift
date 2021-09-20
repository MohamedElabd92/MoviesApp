//
//  GenreListModel.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 20/09/2021.
//

import Foundation

class GenreListModel: Codable {
    var genres: [GenresObject]?
}

class GenresObject: Codable {
    var id: Int?
    var name: String?
}
