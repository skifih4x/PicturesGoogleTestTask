//
//  DetailImageViewController.swift
//  PicturesGoogleTestTask
//
//  Created by Артем Орлов on 07.02.2023.
//

import UIKit
import SDWebImage

final class DetailImageViewController: UIViewController {
    
    // MARK: - UI Element
    
    @IBOutlet weak var detailImage: UIImageView!
    
    var detailImageModel: ImageModel?
    
    var imageIndex = 0
    
    // MARK: - Methods Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLargeImage()
        setColorNavBar()
    }
    
    
    @IBAction func openSiteButton(_ sender: UIButton) {
        openSite()
    }
    
    @IBAction func nextBackButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            nextImage()
        default:
            previousImage()
        }
    }
    
    // MARK: - Private Methods
    
    private func nextImage() {
        if (imageIndex + 1) < self.detailImageModel?.imagesResults.count ?? 1 {
            imageIndex += 1
        } else {
            imageIndex = 0
            outImageAlert(with: "Картинки начались с начала, сделайте новый запрос")
        }
        getLargeImage()
    }
    
    private func previousImage() {
        if (imageIndex - 1) >= 0 {
            imageIndex -= 1
        } else {
            imageIndex = (detailImageModel?.imagesResults.count ?? 1) - 1
            outImageAlert(with: "Картинки начались с конца, сделайте новый запрос")
        }
        getLargeImage()
    }
    
    private func openSite() {
        let vc = WebViewController()
        vc.referenceSite = detailImageModel?.imagesResults[self.imageIndex].link ?? ""
        vc.nameReference = detailImageModel?.imagesResults[self.imageIndex].source
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private func getLargeImage() {
        let scale = UIScreen.main.scale
        let thumbnailSize = CGSize(width: 200 * scale, height: 200 * scale)
        self.detailImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.detailImage.sd_setImage(
            with: URL(string: self.detailImageModel?.imagesResults[imageIndex].original ?? ""),
            placeholderImage: nil,
            context: [.imageThumbnailPixelSize : thumbnailSize]
        )
    }
    
    private func setColorNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
    }
}

// MARK: - UIAlertController

extension DetailImageViewController {
    private func outImageAlert(with message: String) {
        let alert = UIAlertController(title: "No new pictures", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
