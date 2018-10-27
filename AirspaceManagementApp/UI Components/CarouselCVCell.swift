//
//  CarouselCVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/23/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

class CarouselCVCellItem: NSObject {
    var title: String?
    var subtitle: String?
    var bannerImage: UIImage?
    
    public init(title: String, subtitle: String, image: UIImage) {
        self.title = title
        self.subtitle = subtitle
        self.bannerImage = image
    }
}

class CarouselCVCell: UICollectionViewCell {

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureInfo(with object: CarouselCVCellItem) {
        self.titleLabel.text = object.title
        self.subtitleLabel.text = object.subtitle
        self.bannerImage.image = object.bannerImage
    }
}
