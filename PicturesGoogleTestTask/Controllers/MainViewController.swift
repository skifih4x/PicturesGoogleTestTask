//
//  MainViewController.swift
//  PicturesGoogleTestTask
//
//  Created by Артем Орлов on 06.02.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: UI Elements
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    // MARK: Model
    
    weak var timer: Timer?
    var imageModel: ImageModel?
    
    // MARK:  Methods Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

    // MARK: UICollectionViewDataSource, UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageModel?.imagesResults.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        guard let imagesModel2 = imageModel?.imagesResults[indexPath.row] else { return cell }
        cell.configure(with: imagesModel2)
        cell.mainImage.image = nil
        return cell
    }
}

    // MARK: SearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != ""  {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                NetworkManager.shared.parseImage(urlString: "https://serpapi.com/search.json?tbm=isch&ijn=0&api_key=23c8d1f8c626a73431cc5c8716e8c21c7056ad11d059936d40efea8bdc8acb62&q=\(searchText)") { result in
                    switch result {
                    case .success(let success):
                        self?.imageModel = success
                        self?.imagesCollectionView.reloadData()
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            })
        }
    }
    
}
