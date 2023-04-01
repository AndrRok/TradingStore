//
//  NetworkManager.swift
//  TradingStore
//
//  Created by ARMBP on 3/22/23.
//

import UIKit


class NetworkManager {
    static let shared           = NetworkManager()
    private let latestURL       = "https://run.mocky.io/v3/cc0071a1-f06e-48fa-9e90-b1c2a61eaca7"
    private let flashSaleURL    = "https://run.mocky.io/v3/a9ceeb6e-416d-4352-bde6-2203416576ac"
    private let itemURL         = "https://run.mocky.io/v3/f7f99d04-4971-45d5-92e0-70333383c239"
    private let searchURL       = "https://run.mocky.io/v3/4c9cd822-9479-4509-803d-63197e5a9e19"
    
    private init() {}
    
    func getLatestRequest(completed: @escaping (Result<LatestResponse, ErrorMessages>) -> Void) {
        let endpoint = latestURL
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy  = .convertFromSnakeCase
                //decoder.dateDecodingStrategy = .iso8601
                let resultLastests            = try decoder.decode(LatestResponse.self, from: data)
                completed(.success(resultLastests))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    func getFlashSalesRequest(completed: @escaping (Result<FlashSaleResponse, ErrorMessages>) -> Void) {
        let endpoint = flashSaleURL
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy  = .convertFromSnakeCase
                //decoder.dateDecodingStrategy = .iso8601
                let resultFlashSales          = try decoder.decode(FlashSaleResponse.self, from: data)
                completed(.success(resultFlashSales))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
   
    
    func getItemRequest(completed: @escaping (Result<ItemModel, ErrorMessages>) -> Void) {
        let endpoint = itemURL
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy  = .convertFromSnakeCase
                //decoder.dateDecodingStrategy = .iso8601
                let itemModel   = try decoder.decode(ItemModel.self, from: data)
                completed(.success(itemModel))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    func getSearchRequest(completed: @escaping (Result<SearchModel, ErrorMessages>) -> Void) {
        let endpoint = searchURL
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                //decoder.keyDecodingStrategy  = .convertFromSnakeCase
                //decoder.dateDecodingStrategy = .iso8601
                let searchModel   = try decoder.decode(SearchModel.self, from: data)
                completed(.success(searchModel))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    //MARK: - DownLoad image
    func downloadImage(from urlString: String, completed: @escaping(UIImage?)-> Void){        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            completed(image)
        }
        task.resume()
    }
}

