//
//  MoviesViewModel.swift
//  MoviesApp
//
//  Created by Mohamed Elabd on 20/09/2021.
//

import Foundation
import Alamofire

protocol NowPlayingDelegate: AnyObject {
    func getNowPlayingResponse(model: MoviesModel)
}

protocol ErrorDelegate: AnyObject {
    func showErrorMessage(message: String)
}

protocol ConfigurationDelegate: AnyObject {
    func getConfigurationResponse(model: ConfigurationModel)
}

protocol TopRatedDelegate: AnyObject {
    func getTopRatedResponse(model: MoviesModel)
}

protocol GenreListDelegate: AnyObject {
    func getGenreListResponse(model: GenreListModel)
}

class MoviesViewModel {
    var nowPlayingDelegate: NowPlayingDelegate?
    var errorDelegate: ErrorDelegate?
    var configurationDelegate: ConfigurationDelegate?
    var topRatedDelegate: TopRatedDelegate?
    var genreListDelegate: GenreListDelegate?
    
    func getConfig() {
        let url = Constants.getConfigURL()
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { response in
            guard let data = response.data else {return}
            self.printResponse(res: response, url: url)
            
            do {
                switch response.result {
                case .success:
                    let model = try JSONDecoder().decode(ConfigurationModel.self, from: data)
                    self.configurationDelegate?.getConfigurationResponse(model: model)
                    
                case let .failure(error):
                    self.errorDelegate?.showErrorMessage(message: error.errorDescription ?? "")
                }
                
            } catch {
                self.errorDelegate?.showErrorMessage(message: error.localizedDescription)
            }
        }
        
    }
    
    func getNowPlayingList(pageNumber: Int) {
        let url = Constants.getNowPlayingURL(pageNumber: pageNumber)
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { response in
            guard let data = response.data else {return}
            self.printResponse(res: response, url: url)
            
            do {
                switch response.result {
                case .success:
                    let model = try JSONDecoder().decode(MoviesModel.self, from: data)
                    self.nowPlayingDelegate?.getNowPlayingResponse(model: model)
                    
                case let .failure(error):
                    self.errorDelegate?.showErrorMessage(message: error.errorDescription ?? "")
                }
                
            } catch {
                self.errorDelegate?.showErrorMessage(message: error.localizedDescription)
            }
        }
    }
    
    func getTopRatedList(pageNumber: Int) {
        let url = Constants.getTopRatedURL(pageNumber: pageNumber)
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { response in
            guard let data = response.data else {return}
            self.printResponse(res: response, url: url)
            
            do {
                switch response.result {
                case .success:
                    let model = try JSONDecoder().decode(MoviesModel.self, from: data)
                    self.topRatedDelegate?.getTopRatedResponse(model: model)
                    
                case let .failure(error):
                    self.errorDelegate?.showErrorMessage(message: error.errorDescription ?? "")
                }
                
            } catch {
                self.errorDelegate?.showErrorMessage(message: error.localizedDescription)
            }
        }
    }
    
    func getGenreList() {
        let url = Constants.getGenreListURL()
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { response in
            guard let data = response.data else {return}
            self.printResponse(res: response, url: url)
            
            do {
                switch response.result {
                case .success:
                    let model = try JSONDecoder().decode(GenreListModel.self, from: data)
                    self.genreListDelegate?.getGenreListResponse(model: model)
                    
                case let .failure(error):
                    self.errorDelegate?.showErrorMessage(message: error.errorDescription ?? "")
                }
                
            } catch {
                self.errorDelegate?.showErrorMessage(message: error.localizedDescription)
            }
        }
    }
    
    func printResponse(res: AFDataResponse<Any>, url: String) {
        if let value = res.value {
            print("------- \(url)")
            print("------- response")
            print(value)
        }
    }
}
