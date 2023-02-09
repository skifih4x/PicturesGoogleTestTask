//
//  ImageCell.swift
//  PicturesGoogleTestTask
//
//  Created by Артем Орлов on 07.02.2023.
//

import UIKit
import SDWebImage

final class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImage.image = nil
    }

    func configure(with images: ImageResult) {

        mainImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        mainImage.sd_setImage(with: URL(string: images.thumbnail))
//        mainImage.downloaded(from: images.thumbnail)
    }
}
