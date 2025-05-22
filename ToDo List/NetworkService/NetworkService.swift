//
//  NetworkService.swift
//  ToDo List
//
//  Created by KazbekMusaev on 20.05.2025.
//

import Foundation

final class NetworkService {
    
    private init () {}
    
    static func getData(completion: @escaping (Result<ToDoModel, Error>) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "dummyjson.com"
        urlComponents.path = "/todos"
        guard let url = urlComponents.url else { return }
        let req = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(ToDoModel.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()

    }
    
    
}
