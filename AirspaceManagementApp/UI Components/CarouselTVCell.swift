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
        self.collectionView.register(UINib(nibName: "QuickReserveCVCell", bundle: nil), forCellWithReuseIdentifier: "QuickReserveCVCell")
        self.collectionView.showsHorizontalScrollIndicator = false
        
        setCVLayout()
    }
    
    func setCVLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        guard !items.isEmpty else { return }
        switch items[0].type  {
        case .regular?:
            flowLayout.itemSize = CGSize(width: 200, height: 250)
        case .quickReserve?:
            flowLayout.itemSize = CGSize(width: 100, height: 100)
            flowLayout.minimumInteritemSpacing = CGFloat(20)
        case .none:
            break
        }
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
    }
    
    func setCarouselItems(with list: [CarouselCVCellItem]) {
        self.items = list
        self.collectionView.reloadData()
        setCVLayout()
    }
}

extension CarouselTVCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if !items.isEmpty,
            items[0].type == .quickReserve {
            let cellSpacing = (collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
            let cellSize = (collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width
            let cellCount = CGFloat(collectionView.numberOfItems(inSection: section))
            var inset = (collectionView.bounds.width - (cellCount * cellSize) - ((cellCount-1) * cellSpacing)) * 0.5
            inset = max(inset, 0.0)
            return UIEdgeInsets(top: 0.0, left: inset, bottom: 0.0, right: 0.0)
        }
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}

extension CarouselTVCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currItem = items[indexPath.row]
        switch currItem.type {
        case .regular?:
            var cell = CarouselCVCell()
            if let cvCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCVCell", for: indexPath) as? CarouselCVCell  {
                cell = cvCell
            } else {
                collectionView.register(UINib(nibName: "CarouselCVCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCVCell")
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCVCell", for: indexPath) as! CarouselCVCell
            }
            cell.configureInfo(with: currItem)
            return cell
        case .quickReserve?:
            var cell = QuickReserveCVCell()
            if let tvCell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickReserveCVCell", for: indexPath) as? QuickReserveCVCell  {
                cell = tvCell
            } else {
                self.collectionView.register(UINib(nibName: "QuickReserveCVCell", bundle: nil), forCellWithReuseIdentifier: "QuickReserveCVCell")
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickReserveCVCell", for: indexPath) as! QuickReserveCVCell
            }
            cell.timeRangeLabel.text = currItem.title
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true;
            
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false;
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath

            return cell
        case .none:
            break
        }
        return UICollectionViewCell()
    }
}
