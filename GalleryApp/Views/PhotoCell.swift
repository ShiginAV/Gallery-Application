//
//  PhotoCell.swift
//  GalleryApp
//
//  Created by Alexander on 14.10.2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            guard let image = image else { return }
            imageView.image = image
        }
    }
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let checkMark: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "checkmark"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     override func prepareForReuse() {
         super.prepareForReuse()
         imageView.image = nil
     }
     
     func updateSelectedState() {
         imageView.alpha = isSelected ? 0.7 : 1
         checkMark.alpha = isSelected ? 1 : 0
     }
    
    fileprivate func setupViews() {
        contentView.addSubview(imageView)
        imageView.fillSuperview()
        
        imageView.addSubview(checkMark)
        checkMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        checkMark.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
}
