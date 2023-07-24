//
//  NetworkManager.swift
//  BrowsrApp
//
//  Created by Sunil Zishan on 24.07.23.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "com.example.network", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data received"])
                completion(.failure(error))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
        }
        
        task.resume()
    }
}
