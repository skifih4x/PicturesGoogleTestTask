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
    
    var position: Int?
    
    // MARK: Model

    var imageModel: ImageModel? {
        didSet {
            DispatchQueue.main.async {
                self.imagesCollectionView.reloadData()
            }
        }
    }
    
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
//        cell.mainImage.image = nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "nextVC", sender: nil)
        
    }
    
    // MARK: Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextVC" {
            guard let detailVC = segue.destination as? DetailImageViewController else { return }
            guard let indexPath = imagesCollectionView.indexPathsForSelectedItems?.first else { return }
            detailVC.detailImageModel = imageModel
            detailVC.imageIndex = indexPath.row
        }
    }
}

// MARK: SearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != ""  {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] _ in
                    self?.fetchImage(with: searchText)
                
            })
        }
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
