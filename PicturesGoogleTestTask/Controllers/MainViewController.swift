//
//  MainViewController.swift
//  PicturesGoogleTestTask
//
//  Created by Артем Орлов on 06.02.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    weak var timer: Timer?
    var position: Int?
    var task: DispatchWorkItem!
    
    // MARK: Model
    
    var imageModel: ImageModel? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.imagesCollectionView.reloadData()
            }
        }
    }
    
    // MARK:  Methods Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCollectionView.showsVerticalScrollIndicator = false
        settingSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingColorNavBar() 
    }
    
    // MARK: Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.detailVCSegue.rawValue {
            guard let detailVC = segue.destination as? DetailImageViewController else { return }
            guard let indexPath = imagesCollectionView.indexPathsForSelectedItems?.first else { return }
            detailVC.detailImageModel = imageModel
            detailVC.imageIndex = indexPath.row
        }
    }
    
    // MARK: - Network
    
    private func fetchImage(with request: String) {
        activityIndicator.startAnimating()
        NetworkManager.shared.parseImage(urlString: Constants.url.rawValue + request + Constants.key.rawValue) { [weak self] result in
            DispatchQueue.main.async(execute: {
                switch result {
                case .success(let success):
                    self?.imageModel = success
                    if success.imagesResults.count > 1 {
                        self?.activityIndicator.stopAnimating()
                    }
                case .failure(let failure):
                    self?.fetchError(with: failure.localizedDescription)
                    self?.activityIndicator.stopAnimating()
                }
            })
        }
    }
    
    // MARK: - Private Methods
    
    private func settingSearchBar() {
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.leftView?.tintColor = .black
    }
    
    private func settingColorNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .black
        self.navigationController?.navigationBar.tintColor = .white
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageModel?.imagesResults.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId.rawValue, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        guard let imagesModel2 = imageModel?.imagesResults[indexPath.row] else { return cell }
        cell.configure(with: imagesModel2)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.detailVCSegue.rawValue, sender: nil)
    }
}

// MARK: - SearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if task != nil {
            task.cancel()
        }
        
        guard let filter = searchBar.text?.lowercased(), !filter.isEmpty else {
            imageModel?.imagesResults.removeAll()
            return
        }
        
        task = DispatchWorkItem {
            self.fetchImage(with: filter.removeWhitespace())
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: task)
    }
}

// MARK: - UIAlertController

extension MainViewController {
    private func fetchError(with message: String) {
        let alert = UIAlertController(title: "Проблеммыс с сетью", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

