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
    
    weak var timer: Timer?
    
    // MARK: Model

    var imageModel: ImageModel?
    
    // MARK:  Methods Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Network
    
   private func fetchImage(with request: String) {
       NetworkManager.shared.parseImage(urlString: Constants.url.rawValue + request + Constants.key.rawValue) { [weak self] result in
            switch result {
            case .success(let success):
                self?.imageModel = success
                self?.imagesCollectionView.reloadData()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "nextVC", sender: nil)

    }
}

// MARK: SearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != ""  {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                self?.fetchImage(with: searchText)
            })
        }
    }
}
