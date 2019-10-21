//
//  SliderViewController.swift
//  GalleryApp
//
//  Created by Alexander on 14.10.2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController {
    
    var selectedItemIndexPath = IndexPath()
    var didScrollToSelectedItem = false
    var photos = [Photo]()
    let cellId = "cellId"
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pressedCloseButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    @objc func pressedCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension SliderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !didScrollToSelectedItem {
            collectionView.scrollToItem(at: selectedItemIndexPath, at: .right, animated: false)
            didScrollToSelectedItem = true
        }
    }
}

extension SliderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoCell
        cell.imageView.contentMode = .scaleAspectFit
        
        let photo = photos[indexPath.row]
        NetworkManager.fetchImage(url: photo.bigImageURL) { image in
            cell.image = image
        }
        return cell
    }
}
