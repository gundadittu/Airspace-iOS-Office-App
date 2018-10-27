//
//  CarouselTVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/23/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

class CarouselTVCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var items = [CarouselCVCellItem]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "CarouselCVCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCVCell")
        self.collectionView.showsHorizontalScrollIndicator = false
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 200, height: 200)
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
    }
    
    func setCarouselItems(with list: [CarouselCVCellItem]) {
        self.items = list
        self.collectionView.reloadData()
    }
}

//extension CarouselTVCell: UICollectionViewDelegateFlowLayout {
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 300 , height: 400)
//    }
//
//}

extension CarouselTVCell: UICollectionViewDelegate {
    
}

extension CarouselTVCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = CarouselCVCell()
        if let cvCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCVCell", for: indexPath) as? CarouselCVCell  {
            cell = cvCell
        } else {
            collectionView.register(UINib(nibName: "CarouselCVCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCVCell")
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCVCell", for: indexPath) as! CarouselCVCell
        }
        cell.configureInfo(with: items[indexPath.row])
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        var cell = CarouselCVCell()
//        if let cvCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCVCell", for: indexPath) as? CarouselCVCell  {
//            cell = cvCell
//        } else {
//            collectionView.register(UINib(nibName: "CarouselCVCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCVCell")
//            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCVCell", for: indexPath) as! CarouselCVCell
//        }
//        cell.configureInfo(with: items[indexPath.row])
//        return cell
//    }
}
