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
    var type: CarouselCVCellItemType?
    var data: AnyObject?
    
    public init(title: String, subtitle: String?, image: UIImage? = nil, imageURL: URL? = nil, type: CarouselCVCellItemType? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.bannerImage = image
        self.bannerURL = imageURL
        self.type = type ?? .regular
    }
    
    public init(with duration: Duration) {
        let durationLength = duration.rawValue
        let durationString = (durationLength > 60) ? "\(durationLength/60)" : "\(durationLength)"
        let subtitleString = (durationLength > 60) ? "hrs" : "min"
        self.title = durationString
        self.subtitle = subtitleString
        self.type = .quickReserve
        self.data = duration as AnyObject
    }
    
    public init(with guest: AirGuestRegistration) {
        self.title = guest.guestName ?? "No Name Provided"
        self.subtitle = (guest.expectedVisitDate?.localizedDescription ?? "No visiting date")+" at "+(guest.visitingOffice?.name ?? "No visiting office")
        self.bannerImage = nil
        self.bannerURL = nil
        self.type = .text
        self.data = guest
    }
    
    public init(with sr: AirServiceRequest) {
        self.title = sr.issueType?.title ?? "No Type Provided"
        var subtitleString = (sr.status?.title ?? "No Status")+" • "
        subtitleString += (sr.office?.name ?? "No office provided")
        self.subtitle = subtitleString
        self.bannerImage = nil
        self.bannerURL = nil
        self.type = .text
        self.data = sr
    }
    
    public init(with reservation: AirReservation) {
        if let reservation = reservation as? AirConferenceRoomReservation {
            self.title = reservation.conferenceRoom?.name ?? "No Name"
            var subtitleString = (reservation.startingDate?.localizedDescription ?? "No Start Date")
            subtitleString += " to "
            subtitleString += (reservation.endDate?.localizedDescriptionNoDate ?? "No End Date")
            self.subtitle = subtitleString
            self.bannerImage = reservation.conferenceRoom?.image
            self.type = .regular
            self.data = reservation
        } else if let reservation = reservation as? AirDeskReservation {
            // populate cell here 
            return
        }
       
    }
}

enum CarouselCVCellItemType {
    case regular
    case quickReserve
    case text
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
        } else {
            self.bannerImage.isHidden = true
        }
    }
}
