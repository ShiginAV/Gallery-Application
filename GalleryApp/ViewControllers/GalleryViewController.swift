//
//  GalleryViewController.swift
//  GalleryApp
//
//  Created by Alexander on 14.10.2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    //MARK: - Properties
    var photos = [Photo]()
    let padding: CGFloat = 1
    let cellId = "cellId"
    var isSelectedItems = false
    var selectedImages = [UIImage]()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .systemBackground
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    lazy var addBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonItemTapped))
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    lazy var actionBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonItemTapped))
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    lazy var selectButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "select", style: .plain, target: self, action: #selector(selectBarButtonItemTapped(_:)))
        return barButtonItem
    }()

    //MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        setupNavigationBar()
        setupViews()
        fetchPhotos()
    }
    
    //MARK: - Methods
    fileprivate func setupDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    fileprivate func setupNavigationBar() {
        title = "Gallery"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.leftBarButtonItems = [addBarButtonItem, actionBarButtonItem]
        navigationItem.rightBarButtonItem = selectButton
    }
    
    fileprivate func setupViews() {
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    fileprivate func showAlert() {
        let alert = UIAlertController(title: "Sorry!", message: "Photos not found", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func fetchPhotos(by text: String? = nil) {
        NetworkManager.fetchPhotos(by: text) { [weak self] photos in
             guard let strongSelf = self else { return }
             guard let photos = photos, photos.count > 0 else {
                 strongSelf.showAlert()
                 return
             }
             strongSelf.photos = photos
             strongSelf.collectionView.reloadData()
         }
    }
    
    fileprivate func updateBarButtonItems() {
        addBarButtonItem.isEnabled = isSelectedItems && selectedImages.count > 0
        actionBarButtonItem.isEnabled = isSelectedItems && selectedImages.count > 0
    }
    
    @objc func addBarButtonItemTapped() {
        print("add")
    }
    
    @objc func actionBarButtonItemTapped() {
        let activityController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        activityController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.deselectAllItems()
                self.updateBarButtonItems()
            }
        }
        present(activityController, animated: true)
    }
    
    @objc func selectBarButtonItemTapped(_ sender: UIBarButtonItem) {
        isSelectedItems.toggle()
        sender.title = isSelectedItems ? "cancel" : "select"
        sender.style = isSelectedItems ? .done : .plain

        deselectAllItems()
        updateBarButtonItems()
    }
    
    fileprivate func deselectAllItems() {
        collectionView.indexPathsForSelectedItems?.forEach({
            collectionView.deselectItem(at: $0, animated: false)
            setCellSelected(false, indexPath: $0)
        })

        selectedImages.removeAll()
        collectionView.reloadData()
    }
    
    fileprivate func setCellSelected(_ isSelected: Bool, indexPath: IndexPath) {
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            selectedCell.isSelected = isSelected
            selectedCell.updateSelectedState()

            if let image = selectedCell.image {
                if isSelected {
                    selectedImages.append(image)
                } else {
                    if let index = selectedImages.firstIndex(of: image) {
                        selectedImages.remove(at: index)
                    }
                }
            }
            updateBarButtonItems()
        }
    }
}

//MARK: - UICollectionViewDelegate
extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isSelectedItems {
            setCellSelected(true, indexPath: indexPath)
        } else {
            let imageURL = photos[indexPath.row].bigImageURL
            NetworkManager.fetchImage(url: imageURL) { [weak self] image in
                guard let strongSelf = self else { return }
                let sliderViewController = SliderViewController()
                sliderViewController.photos = strongSelf.photos
                sliderViewController.selectedItemIndexPath = indexPath
                strongSelf.present(sliderViewController, animated: true, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isSelectedItems {
            setCellSelected(false, indexPath: indexPath)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewHeight = view.frame.height
        let viewWidth = view.frame.width
        let cellWidth = viewHeight > viewWidth ? (viewWidth - padding * 2) / 3 : (viewWidth - padding * 3 * 2) / 6
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

//MARK: - UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoCell
        cell.updateSelectedState()

        let photo = photos[indexPath.row]
        NetworkManager.fetchImage(url: photo.smallImageURL) { image in
            cell.image = image
        }
        return cell
    }
}

//MARK: - UISearchBarDelegate
extension GalleryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text != "" else { return }
        fetchPhotos(by: text)
    }
}

