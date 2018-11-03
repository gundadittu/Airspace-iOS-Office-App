//
//  SubmitTicketTableViewCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/21/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit

class SubmitTicketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    var field: SubmitTicketField? 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainButton.tintColor = .black
    }
    
    func setMainButtonText(string: String) {
        let attrs = [ .font: UIFont(name: "AvenirNext-Medium", size: 30)!, NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        let buttonTitleStr = NSMutableAttributedString(string:"Building X", attributes:attrs)
        mainButton.setAttributedTitle(buttonTitleStr, for: .normal)
    }
    
    @IBAction func mainButtonTapped(_ sender: Any) {
        return
    }
    
}
