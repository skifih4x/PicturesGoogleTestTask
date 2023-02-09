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
    
//    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
//    }
//    
//    func downloadImage(from url: URL) {
//        print("Download Started")
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            // always update the UI from the main thread
//            DispatchQueue.main.async() { [weak self] in
//                self?.imageView.image = UIImage(data: data)
//            }
//        }
//    }
    
    func parseImage(urlString: String, completion: @escaping ( Result <ImageModel, Error> ) -> Void ) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(error!))
                print(error?.localizedDescription ?? "Error")
                return
            }
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
