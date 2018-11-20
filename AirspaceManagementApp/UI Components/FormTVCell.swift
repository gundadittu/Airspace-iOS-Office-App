//
//  FormTVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/19/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

protocol FormTVCellDelegate  {
    func didSelectCellButton(withObject: PageSection)
}

class FormTVCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    var sectionObject: PageSection?
    var delegate: FormTVCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.button.tintColor = globalColor
    }

    func configureCell(with object: RegisterGuestVCSection, delegate: FormTVCellDelegate) {
        self.delegate = delegate
        self.sectionObject = object
        
        self.titleLabel.text = object.title
        
        let attrs = [NSAttributedString.Key.underlineStyle : 1]
        let attributedString = NSMutableAttributedString(string:object.buttonTitle, attributes: attrs)
        self.button.setAttributedTitle(attributedString, for: .normal)
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        guard let so = self.sectionObject else { return }
        self.delegate?.didSelectCellButton(withObject: so)
    }
}
