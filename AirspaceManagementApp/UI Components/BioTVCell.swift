//
//  BioTVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/26/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

class BioTVCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImg.layer.cornerRadius = self.profileImg.frame.height/2
        self.profileImg.layer.masksToBounds = false
        self.profileImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
