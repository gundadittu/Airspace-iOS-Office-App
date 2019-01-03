//
//  CarouselTVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/23/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

protocol CarouselTVCellDelegate {
    func didSelectCarouselCVCellItem(item: CarouselCVCellItem)
    func titleForEmptyState(for identifier: String?) -> String
    func descriptionForEmptyState(for identifier: String?) -> String
    func imageForEmptyState(for identifier: String?) -> UIImage
    func isLoadingData(for identifier: String?) -> Bool
}

class CarouselTVCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var items = [CarouselCVCellItem]()
    var delegate: CarouselTVCellDelegate?
    var identifier: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.emptyDataSetSource = self
        self.collectionView.emptyDataSetDelegate = self
        
        self.collectionView.register(UINib(nibName: "CarouselCVCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCVCell")
        self.collectionView.register(UINib(nibName: "QuickReserveCVCell", bundle: nil), forCellWithReuseIdentifier: "QuickReserveCVCell")
        self.collectionView.register(UINib(nibName: "TextCVCell", bundle: nil), forCellWithReuseIdentifier: "TextCVCell")
        self.collectionView.showsHorizontalScrollIndicator = false
        self.setCVLayout()
    }
    
    func setCVLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        guard !items.isEmpty else { return }
        switch items[0].type  {
        case .regular?:
            let size = self.collectionView.superview?.bounds.size
            
            let width = (UIDevice.current.userInterfaceIdiom == .pad) ? CGFloat(330) :(size?.width ?? CGFloat(270)) - CGFloat(60)
            let height = (size?.height ?? CGFloat(170)) - CGFloat(20)
            flowLayout.itemSize = CGSize(width: width, height: height)
        case .quickReserve?:
            flowLayout.itemSize = CGSize(width: 100, height: 100)
            flowLayout.minimumInteritemSpacing = CGFloat(20)
        case .none:
            break
        case .some(.text):
            flowLayout.itemSize = CGSize(width: 200, height: 100)
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
            var inset = (collectionView.bounds.width - (cellCount * cellSize) - ((cellCount-2) * cellSpacing)) * 0.5
            inset = max(inset, 0.0)
            return UIEdgeInsets(top: 0.0, left: inset, bottom: 0.0, right: 0.0)
        }
        return UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    }
}

extension CarouselTVCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        self.delegate?.didSelectCarouselCVCellItem(item: item)
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
            cell.subtitleLabel.text = currItem.subtitle
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
        case .some(.text):
            var cell = TextCVCell()
            if let cvCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCVCell", for: indexPath) as? TextCVCell  {
                cell = cvCell
            } else {
                collectionView.register(UINib(nibName: "TextCVCell", bundle: nil), forCellWithReuseIdentifier: "TextCVCell")
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCVCell", for: indexPath) as! TextCVCell
            }
            cell.configureInfo(with: currItem)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension CarouselTVCell: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if let isLoading = self.delegate?.isLoadingData(for: self.identifier),
            isLoading == true {
            let attributedString = NSMutableAttributedString(string: "Loading...", attributes: globalBoldTextAttrs)
            return attributedString
        } else {
            let text = self.delegate?.titleForEmptyState(for: self.identifier)
            return NSMutableAttributedString(string: text ?? "", attributes: globalBoldTextAttrs)
        }
    }
    
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if let isLoading = self.delegate?.isLoadingData(for: self.identifier),
            isLoading == true {
            let attributedString = NSMutableAttributedString(string: "", attributes: globalTextAttrs)
            return attributedString
        } else {
            let text = self.delegate?.descriptionForEmptyState(for: self.identifier)
            return NSMutableAttributedString(string: text ?? "", attributes: globalTextAttrs)
        }
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if let isLoading = self.delegate?.isLoadingData(for: self.identifier),
            isLoading == true {
            return UIImage()
        }
        return self.delegate?.imageForEmptyState(for: self.identifier) ?? UIImage()
    }
}
