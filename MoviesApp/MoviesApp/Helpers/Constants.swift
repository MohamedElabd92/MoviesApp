//
//  Constants.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 20/09/2021.
//

import Foundation

class Constants {
    static let apiKey = "ebcd0d9025b4669e6ada5ce24a0e6d86"
    static let baseUrl = "https://api.themoviedb.org/3/"
    static let nowPlaying = "movie/now_playing"
    static let topRated = "movie/top_rated"
    static let genreList = "genre/movie/list"
    static let searchMovie = "search/movie"
    static let config = "configuration"
    
    static func getNowPlayingURL(pageNumber: Int) -> String {
        let nowPlayingUrl = baseUrl + nowPlaying
        var fullUrl = URLComponents(string: nowPlayingUrl) ?? URLComponents()
        
        fullUrl.queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                              URLQueryItem(name: "language", value: "en-US"),
                              URLQueryItem(name: "page", value: "\(pageNumber)")]
        
        return fullUrl.url?.absoluteString ?? ""
    }
    
    static func getConfigURL() -> String {
        let configUrl = baseUrl + config
        var fullUrl = URLComponents(string: configUrl) ?? URLComponents()
        fullUrl.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        return fullUrl.url?.absoluteString ?? ""
    }
    
    static func getTopRatedURL(pageNumber: Int) -> String {
        let topRatedUrl = baseUrl + topRated
        var fullUrl = URLComponents(string: topRatedUrl) ?? URLComponents()
        
        fullUrl.queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                              URLQueryItem(name: "language", value: "en-US"),
                              URLQueryItem(name: "page", value: "\(pageNumber)")]
        
        return fullUrl.url?.absoluteString ?? ""
    }
    
    static func getGenreListURL() -> String {
        let genreListUrl = baseUrl + genreList
        var fullUrl = URLComponents(string: genreListUrl) ?? URLComponents()
        
        fullUrl.queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                              URLQueryItem(name: "language", value: "en-US")]
        
        return fullUrl.url?.absoluteString ?? ""
    }
    
    static func getSearchURL(pageNumber: Int, searchText: String) -> String {
        let searchListUrl = baseUrl + searchMovie
        var fullUrl = URLComponents(string: searchListUrl) ?? URLComponents()
        
        fullUrl.queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                              URLQueryItem(name: "language", value: "en-US"),
                              URLQueryItem(name: "query", value: searchText),
                              URLQueryItem(name: "page", value: "\(pageNumber)")]
        
        return fullUrl.url?.absoluteString ?? ""
    }
}
