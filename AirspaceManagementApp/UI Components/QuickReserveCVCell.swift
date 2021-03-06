//
//  QuickReserveCVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/27/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

class QuickReserveCVCell: UICollectionViewCell {

    @IBOutlet weak var timeRangeLabel: UILabel!
    var duration: Duration?
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = globalColor
        self.timeRangeLabel.textColor = .white
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.size.width / 2
    }

}
