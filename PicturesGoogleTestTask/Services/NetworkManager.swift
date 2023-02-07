//
//  NetworkManager.swift
//  PicturesGoogleTestTask
//
//  Created by Артем Орлов on 07.02.2023.
//

import Foundation

final class NetworkManager {
    
     static let shared = NetworkManager()
//    let string = "https://serpapi.com/search.json?tbm=isch&ijn=0&api_key=23c8d1f8c626a73431cc5c8716e8c21c7056ad11d059936d40efea8bdc8acb62&q=5"
    
    func parseImage(urlString: String, completion: @escaping ( Result <ImageModel, Error> ) -> Void ) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(error!))
                print(error?.localizedDescription ?? "Error")
                return
            }
            print(data)
            do {
                let image = try JSONDecoder().decode(ImageModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } catch let error {
                print(error)
            }
        }
        .resume()
    }
    
}
