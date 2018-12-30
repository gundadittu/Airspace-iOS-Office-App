//
//  CarouselCVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/23/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

enum CarouselCVCellItemType {
    case regular
    case quickReserve
    case text
}

class CarouselCVCell: UICollectionViewCell {

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        self.bannerImage.addBlackGradientLayer(frame: self.frame, colors: [.clear,.black])
        
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 1
        self.contentView.layer.shadowOffset = CGSize.zero
        self.contentView.layer.shadowRadius = 10
    }
    
    func configureInfo(with object: CarouselCVCellItem) {
        self.titleLabel.text = object.title
        self.subtitleLabel.text = object.subtitle
        if let image = object.bannerImage {
            self.bannerImage.image = image
        } else if let _ = object.bannerURL {
//            self.bannerImage.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            return
        } else {
            self.bannerImage.isHidden = true
        }
    }
}
