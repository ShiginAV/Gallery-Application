//
//  Photos.swift
//  GalleryApp
//
//  Created by Alexander on 15.10.2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import Foundation

struct Photos: Codable {
    
    var photoList: [Photo]
        
    enum CodingKeys: String, CodingKey {
        case photos
        case photoList = "photo"
    }
        
    //Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let photosContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .photos)
        self.photoList = try photosContainer.decode([Photo].self, forKey: .photoList)
    }
    
    //Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var photosContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .photos)
        try photosContainer.encode(photoList, forKey: .photoList)
    }
}
