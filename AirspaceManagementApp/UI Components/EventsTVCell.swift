//
//  EventsTVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/27/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseStorage

protocol EventsTVCellDelegate {
    func didTapCell(with event: AirEvent)
}

class EventsTVCell: UITableViewCell {
    let storageRef = Storage.storage().reference()

    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var organizerLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    var tapGesture: UITapGestureRecognizer?
    var event: AirEvent?
    var delegate: EventsTVCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bannerImage.layer.cornerRadius = 10.0
        self.bannerImage.layer.masksToBounds = true
        self.bannerImage.addBlackGradientLayer(frame: self.frame, colors: [.clear,.black])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EventsTVCell.didTap(_:)))
        self.tapGesture = tapGesture
        self.bannerImage.addGestureRecognizer(tapGesture)
        self.bannerImage.isUserInteractionEnabled = true
        self.stackView.addGestureRecognizer(tapGesture)
        self.stackView.isUserInteractionEnabled = true
    }
    
    public func configure(with event: AirEvent, delegate: EventsTVCellDelegate) {
        self.event = event
        self.delegate = delegate
        self.titleLabel.text = event.title ?? "No Event Name Provided"
        self.organizerLabel.text = event.address ?? "No event address provided"
        if let startText = self.event?.startDate?.localizedDescription,
            let endText = self.event?.endDate?.localizedShortTimeDescription {
            let text = startText+" to "+endText
            self.addressLabel.text = text
        } else {
            self.addressLabel.isHidden = false
        }
        
        guard let uid = event.uid else { return }
        let imageRef = storageRef.child("eventPhotos/\(uid).jpg")
        self.bannerImage.sd_setImage(with: imageRef, placeholderImage: UIImage(named: "placeholder")!)
    }
    
    @objc func didTap(_ tapGesture: UITapGestureRecognizer) {
        guard let event = self.event else { return }
        self.delegate?.didTapCell(with: event)
    }
}
