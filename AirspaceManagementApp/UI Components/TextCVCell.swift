//
//  TextCVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/22/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

class TextCVCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.contentView.layer.borderColor = globalColor.cgColor
//        self.contentView.layer.borderWidth = CGFloat(0.5)
        self.contentView.layer.cornerRadius = CGFloat(5)
        self.contentView.layer.backgroundColor = globalColor.cgColor
        self.titleLabel.textColor = .white
        self.subtitleLabel.textColor = .white
    }
    
    func configureInfo(with item: CarouselCVCellItem) {
        self.titleLabel.text = item.title
        self.subtitleLabel.text = item.subtitle
    }

}
