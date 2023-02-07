//
//  ImageCell.swift
//  PicturesGoogleTestTask
//
//  Created by Артем Орлов on 07.02.2023.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!

    func configure(with images: ImageResult) {
        DispatchQueue.global().async {
            guard let url = URL(string: images.thumbnail) else {return}
            guard let imageData = try? Data(contentsOf: url) else {return}
            DispatchQueue.main.async {
                self.mainImage.image = UIImage(data: imageData)
            }
        }
    }
}
