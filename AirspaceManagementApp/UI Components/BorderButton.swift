//
//  BorderButton.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/21/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import SwiftyButton

class BorderButton: FlatButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTitleColor(globalColor, for: .normal)
        self.color = .white
        self.highlightedColor = .lightGray
        self.selectedColor = .white
        self.layer.borderColor = globalColor.cgColor
        self.layer.borderWidth = CGFloat(1)
        self.layer.cornerRadius = CGFloat(5)
    }
}
