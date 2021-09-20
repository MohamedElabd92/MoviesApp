//
//  ConfigurationModel.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 20/09/2021.
//

import Foundation

class ConfigurationModel: Codable {
    var change_keys: [String]?
    var images: ImagesObject?
}

class ImagesObject: Codable {
    var base_url: String?
    var secure_base_url: String?
    var backdrop_sizes: [String]?
    var logo_sizes: [String]?
    var poster_sizes: [String]?
    var profile_sizes: [String]?
    var still_sizes: [String]?
}
