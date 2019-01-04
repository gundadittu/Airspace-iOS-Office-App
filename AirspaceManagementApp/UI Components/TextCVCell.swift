//
//  TextCVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/22/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import ChameleonFramework

class TextCVCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = CGFloat(5)
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = globalColor
        self.backgroundImage.isHidden = true
        self.titleLabel.textColor = .white
        self.subtitleLabel.textColor = .white
    }
    
    func configureInfo(with item: CarouselCVCellItem) {
        self.titleLabel.text = item.title
        self.subtitleLabel.text = item.subtitle
    }

}
