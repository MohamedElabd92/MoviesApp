//
//  Utility.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 20/09/2021.
//

import Foundation
import SystemConfiguration

class Utility {
    static func getFavoriteMovies() -> [ResultsObject] {
        let model = ResultsObject()
        if let objects = UserDefaults.standard.value(forKey: "FavoriteData") as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [ResultsObject] {
                return objectsDecoded
            } else {
                return [model]
            }
        } else {
            return []
        }
    }
    
    static func addToFavoriteMovies(data: ResultsObject) {
        var allMovies = getFavoriteMovies()
        allMovies.append(data)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allMovies) {
            UserDefaults.standard.set(encoded, forKey: "FavoriteData")
            UserDefaults.standard.synchronize()
        }
    }
    
    static func removeFromFavoriteMovies(data: ResultsObject) {
        var allMovies = getFavoriteMovies()
        
        var index = 0
        for item in allMovies {
            
            if item.id == data.id {
                allMovies.remove(at: index)
                break
            }
            index += 1
        }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allMovies) {
            UserDefaults.standard.set(encoded, forKey: "FavoriteData")
            UserDefaults.standard.synchronize()
        }
    }
}
