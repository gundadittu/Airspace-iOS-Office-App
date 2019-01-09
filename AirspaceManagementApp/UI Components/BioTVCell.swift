//
//  BioTVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/26/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

protocol BioTVCellDelegate {
    func didTapImage()
}

class BioTVCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    var delegate: BioTVCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImg.layer.cornerRadius = self.profileImg.frame.height/2
        self.profileImg.layer.masksToBounds = false
        self.profileImg.clipsToBounds = true
        self.profileImg.layer.borderWidth = CGFloat(1)
        self.profileImg.layer.borderColor = UIColor.lightGray.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage(_:)))
        self.profileImg.isUserInteractionEnabled = true 
        self.profileImg.addGestureRecognizer(tapGesture)
        
        self.addEditLabel()
    }
    
    @objc func didTapImage(_ tapGesture: UITapGestureRecognizer) {
        self.delegate?.didTapImage()
    }
    
    func setProfileImage(with image: UIImage?) {
        let image = image ?? UIImage(named: "user-placeholder")
        self.profileImg.image = image
    }
    
    func addEditLabel() {
        let string = "Edit"
        let backgroundColorOriginal = UIColor.flatWhite.darken(byPercentage: CGFloat(0.1))
        let backgroundColor = backgroundColorOriginal?.withAlphaComponent(CGFloat(0.8))
        
        let viewWidth = self.profileImg.frame.width
        let viewHeight = self.profileImg.frame.height/5
        let yPoint = (self.profileImg.frame.height) - viewHeight
        let frame = CGRect(x: CGFloat(0), y: yPoint, width: viewWidth, height: viewHeight)
        let view = UIView(frame: frame)
        view.backgroundColor = backgroundColor
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        label.textColor = .white
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        var localAttrs = globalWhiteTextAttrs
        localAttrs[NSAttributedString.Key.paragraphStyle] = paragraph
        let attributedString = NSMutableAttributedString(string: string, attributes: localAttrs)
        label.attributedText = attributedString
        view.addSubview(label)
        
        self.profileImg.addSubview(view)
    }
}
