//
//  NetworkServices.swift
//  News App
//
//  Created by Asalah Sayed on 30/07/2023.
//

import Foundation
protocol NetworkServicesProtocol {
    func getTopHeadLines(completion: @escaping (Result<[Article], Error>) -> Void)
}
final class NetworkServices: NetworkServicesProtocol{
//    static let shared  = NetworkServices()
    
    struct Constants {
        static let topHeadLinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=fc6b500af7ee428194657651d145e85e")
    }
//    private init() {}
    
    public func getTopHeadLines(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadLinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data {
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles!))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

