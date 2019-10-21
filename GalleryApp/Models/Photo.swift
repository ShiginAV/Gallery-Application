//
//  Photo.swift
//  GalleryApp
//
//  Created by Alexander on 14.10.2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import UIKit

struct Photo: Codable {
    
    var smallImageURL: URL
    var bigImageURL: URL
   
    enum CodingKeys: String, CodingKey {
        case smallImageURL = "url_q"
        case bigImageURL = "url_z"
    }
}
