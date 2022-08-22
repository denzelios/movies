//
//  NetworkService.swift
//  movieSearch
//
//  Created by Андрей Цуркан on 05.08.2022.
//

import Foundation

class NetworkService{
    
    func request(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                
                if let error = error{
                    print("Some ERROR")
                    
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else { return }
                completion(.success(data))
            }
        }
        task.resume()
    }
}
