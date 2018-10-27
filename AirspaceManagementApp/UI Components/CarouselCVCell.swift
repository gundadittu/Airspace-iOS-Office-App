//
//  CarouselCVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/23/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import Kingfisher

class CarouselCVCellItem: NSObject {
    var title: String?
    var subtitle: String?
    var bannerImage: UIImage?
    var bannerURL: URL?
    
    public init(title: String, subtitle: String, image: UIImage? = nil, imageURL: URL? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.bannerImage = image
        self.bannerURL = imageURL
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
        if let image = object.bannerImage {
            self.bannerImage.image = image
        } else if let url = object.bannerURL {
            self.bannerImage.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
}
