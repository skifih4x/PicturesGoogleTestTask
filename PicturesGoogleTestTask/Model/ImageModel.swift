//
//  ImageModel.swift
//  PicturesGoogleTestTask
//
//  Created by Артем Орлов on 07.02.2023.
//

struct ImageModel: Decodable {
    var imagesResults: [ImageResult]
    
    enum CodingKeys: String, CodingKey {
        case imagesResults = "images_results"
    }
}

struct ImageResult: Decodable {
    let position: Int
    let thumbnail: String
    let source: String
    let link: String
    let original: String
}
