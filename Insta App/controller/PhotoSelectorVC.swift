//
//  PhotoSelectorVC.swift
//  Insta App
//
//  Created by hosam on 4/24/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    var imageStorageArray = [UIImage]()
    var selectedImage:UIImage?
    var assets = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))

        collectionView.backgroundColor = .white
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(PhotoSelectorHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)

        fetchPhotos()
    }
    
    fileprivate func assetsFetchOption() ->PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    fileprivate func fetchPhotos(){
       let allPhotos = PHAsset.fetchAssets(with: assetsFetchOption())
        DispatchQueue.global(qos: .background).async {
            
            allPhotos.enumerateObjects { (asset, count, stop) in
                print(count)
                let imageManager = PHImageManager.default()
                let size = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: options, resultHandler: { (images, info) in
                    guard let image = images else{return}
                    self.imageStorageArray.append(image)
                    self.assets.append(asset)
                    if self.selectedImage == nil {
                        self.selectedImage = image
                    }
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        
                    }
                })
                
            }
        }
        
    }
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //MARK: -collectionView data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageStorageArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = imageStorageArray[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        cell.fullImage.image = index
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
        String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
            headerId, for: indexPath) as! PhotoSelectorHeaderCell
//        header.selectedImage.image = selectedImage
        
        if let selectImage = selectedImage {
            if let index = self.imageStorageArray.index(of: selectImage) {
                let selectAsset = assets[index]
                
                let imageManage = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                
                imageManage.requestImage(for: selectAsset, targetSize: targetSize, contentMode: .default, options: nil) { (imagee, info) in
                    header.selectedImage.image = imagee
                }
            }
        }
       
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         selectedImage = imageStorageArray[indexPath.row]
        self.collectionView.reloadData()
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        
        return .init(width: width, height: width)
    }
    
    //MARK: -user methods
    
    
    //TODO: -handle methods
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext(){
        print(321)
    }
}
