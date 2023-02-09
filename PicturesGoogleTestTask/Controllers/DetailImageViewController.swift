//
//  DetailImageViewController.swift
//  PicturesGoogleTestTask
//
//  Created by Артем Орлов on 07.02.2023.
//

import UIKit
import SDWebImage

class DetailImageViewController: UIViewController {
    
    @IBOutlet weak var detailImage: UIImageView!
    
    var detailImageModel: ImageModel?
    
    var imageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scale = UIScreen.main.scale // Will be 2.0 on 6/7/8 and 3.0 on 6+/7+/8+ or later
        let thumbnailSize = CGSize(width: 200 * scale, height: 200 * scale)
        DispatchQueue.main.async {
            self.detailImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.detailImage.sd_setImage(
                with: URL(string: self.detailImageModel?.imagesResults[self.imageIndex].original ?? ""),
                placeholderImage: nil,
                context: [.imageThumbnailPixelSize : thumbnailSize]
            )
        }
    }
    
    @IBAction func openSiteButton(_ sender: UIButton) {
        let vc = WebViewController()
        vc.referenceSite = detailImageModel?.imagesResults[self.imageIndex].link ?? ""
        vc.nameReference = detailImageModel?.imagesResults[self.imageIndex].source
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    @IBAction func nextBackButton(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            if imageIndex < detailImageModel?.imagesResults.count ?? 0 {
                imageIndex += 1
                let scale = UIScreen.main.scale // Will be 2.0 on 6/7/8 and 3.0 on 6+/7+/8+ or later
                let thumbnailSize = CGSize(width: 200 * scale, height: 200 * scale)
                DispatchQueue.main.async {
                    self.detailImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.detailImage.sd_setImage(
                        with: URL(string: self.detailImageModel?.imagesResults[self.imageIndex].original ?? ""),
                        placeholderImage: nil,
                        context: [.imageThumbnailPixelSize : thumbnailSize]
                    )
                }
            }
        default:
            if imageIndex < detailImageModel?.imagesResults.count ?? 0 {
                imageIndex -= 1
                let scale = UIScreen.main.scale // Will be 2.0 on 6/7/8 and 3.0 on 6+/7+/8+ or later
                let thumbnailSize = CGSize(width: 200 * scale, height: 200 * scale)
                DispatchQueue.main.async {
                    self.detailImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.detailImage.sd_setImage(
                        with: URL(string: self.detailImageModel?.imagesResults[self.imageIndex].original ?? ""),
                        placeholderImage: nil,
                        context: [.imageThumbnailPixelSize : thumbnailSize]
                    )
                }
            }
        }
    }
}
