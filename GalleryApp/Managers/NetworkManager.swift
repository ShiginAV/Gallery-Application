//
//  NetworkManager.swift
//  GalleryApp
//
//  Created by Alexander on 14.10.2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static func fetchPhotos(by text: String? = nil, completion: @escaping ([Photo]?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.flickr.com"
        urlComponents.path = "/services/rest/"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: "c76a1f2e9ac60481a1469852d0ace915"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "extras", value: "url_q,url_z"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "sort", value: "relevance"),
            URLQueryItem(name: "per_page", value: "30"),
            URLQueryItem(name: "text", value: text)
        ]
        let value = text == nil ? "flickr.interestingness.getList" : "flickr.photos.search"
        urlComponents.queryItems?.append(URLQueryItem(name: "method", value: value))
        
        guard let url = urlComponents.url else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let photos = try? JSONDecoder().decode(Photos.self, from: data)
            
            DispatchQueue.main.async {
                completion(photos?.photoList)
            }
        }.resume()
    }
    
    static func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
