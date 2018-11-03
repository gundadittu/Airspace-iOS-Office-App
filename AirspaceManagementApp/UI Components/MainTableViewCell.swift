//
//  MainTableViewCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/17/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.layer.cornerRadius = CGFloat(5)
        self.titleLabel.textColor = .black
        self.subtitleLabel.textColor = .gray
//        self.layer.borderColor = FlatBlack().cgColor
//        self.layer.borderWidth = CGFloat(1)
    }
}
