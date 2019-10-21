//
//  Extensions+UIView.swift
//  GalleryApp
//
//  Created by Alexander on 17.10.2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import UIKit

extension UIView {
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superViewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superViewTopAnchor, constant: padding.top).isActive = true
        }
        if let superViewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superViewLeadingAnchor, constant: padding.left).isActive = true
        }
        if let superViewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superViewTrailingAnchor, constant: -padding.right).isActive = true
        }
        if let superViewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superViewBottomAnchor, constant: padding.bottom).isActive = true
        }
    }
}
