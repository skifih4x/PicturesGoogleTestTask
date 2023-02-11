//
//  NetworkManager.swift
//  PicturesGoogleTestTask
//
//  Created by Артем Орлов on 07.02.2023.
//

import Foundation
import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let session: URLSession = {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 10
        cfg.timeoutIntervalForResource = 10
        return URLSession(configuration: cfg)
    }()
    
    func parseImage(urlString: String, completion: @escaping ( Result <ImageModel, Error> ) -> Void ) {
        guard let url = URL(string: urlString) else { return }
        self.session.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(error!))
                print(error?.localizedDescription ?? "Error")
                return
            }
            
            do {
                let image = try JSONDecoder().decode(ImageModel.self, from: data)
                completion(.success(image))
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
