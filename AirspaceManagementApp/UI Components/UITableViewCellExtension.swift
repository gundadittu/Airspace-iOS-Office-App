//
//  UITableViewCellExtension.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    func configureCell(with user: AirUser, accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator ) {
        
        self.accessoryType = accessoryType
        let text = user.displayName ?? "No name"
        let detailText = user.email ?? "No email provided"
        self.textLabel?.attributedText = NSMutableAttributedString(string: text, attributes: globalTextAttrs)
        self.detailTextLabel?.attributedText = NSMutableAttributedString(string: detailText, attributes: globalTextAttrs)
        // show proper profile image
//        self.imageView?.image = UIImage(named: "user-placeholder")!
    }
    
    func configureCell(with building: AirBuilding) {

        self.accessoryType = .disclosureIndicator
        let text = building.name ?? "No building name"
        let detailText = building.address ?? "No address provided"
        self.textLabel?.attributedText = NSMutableAttributedString(string: text, attributes: globalTextAttrs)
        self.detailTextLabel?.attributedText = NSMutableAttributedString(string: detailText, attributes: globalTextAttrs)
        // show proper image
//        self.imageView?.image = UIImage(named: "user-placeholder")!
    }
    
    func configureCell(with company: AirCompany) {

        self.accessoryType = .disclosureIndicator
        let text = company.name ?? "No company name"
        self.textLabel?.attributedText = NSMutableAttributedString(string: text, attributes: globalTextAttrs)
        // self.detailTextLabel?.text = company.address ?? "No address provided"
        // show proper  image
//        self.imageView?.image = UIImage(named: "user-placeholder")!
    }
    
    func configureCell(with office: AirOffice) {
        
        self.accessoryType = .disclosureIndicator
        let text = office.name ?? "No office name"
        let detailText = (office.building?.name ?? "No building name provided")
        self.textLabel?.attributedText = NSMutableAttributedString(string: text, attributes: globalTextAttrs)
        self.detailTextLabel?.attributedText = NSMutableAttributedString(string: detailText, attributes: globalTextAttrs)
        
        // show proper  image
//        self.imageView?.image = UIImage(named: "user-placeholder")!
    }
    
    func configureCell(with guest: AirGuestRegistration) {
        let text = guest.guestName ?? "No guest name"
        let detailText = (guest.expectedVisitDate?.localizedDescription ?? "No visiting date")+" at "+(guest.visitingOffice?.name ?? "No visiting office")
        self.textLabel?.attributedText = NSMutableAttributedString(string: text, attributes: globalTextAttrs)
        self.detailTextLabel?.attributedText = NSMutableAttributedString(string: detailText, attributes: globalTextAttrs)
    }
    
//    func configureCell(with notification: AirNotification) {
//        guard let type = notification.type else { return
//    
//        switch type {
//        case .serviceRequestUpdate:
//            let text = type.title
//            let detailText = "service request subtitle"
//            self.textLabel?.attributedText = NSMutableAttributedString(string: text, attributes: attrs)
//            self.detailTextLabel?.attributedText = NSMutableAttributedString(string: detailText, attributes: attrs)
//            self.imageView?.image = UIImage(named: "serv-req-icon")
//        case .arrivedGuestUpdate:
//            let text = type.title
//            let detailText = "guest subtitle"
//            self.textLabel?.attributedText = NSMutableAttributedString(string: text, attributes: attrs)
//            self.detailTextLabel?.attributedText = NSMutableAttributedString(string: detailText, attributes: attrs)
//            self.imageView?.image = UIImage(named: "register-guest-icon")
//        }
//    }

    
    func configureCell(with srType: ServiceRequestTypeItem) {
        let text = srType.title
        self.textLabel?.attributedText = NSMutableAttributedString(string: text, attributes: globalTextAttrs)
    }
    
    func configureCell(with duration: Duration) {
        let text = duration.description
        self.textLabel?.attributedText = NSMutableAttributedString(string: text, attributes: globalTextAttrs)
    }
    
    func configureCell(with amenity: RoomAmenity, selected: Bool) {
        let text = amenity.description
        self.textLabel?.attributedText = NSMutableAttributedString(string: text, attributes: globalTextAttrs)
        self.accessoryType = (selected == true) ? .checkmark : .none
    }
    
    
    func configureCell(with capacity: Int) {
        if capacity == 0 || capacity == 1 {
            self.textLabel?.text = "\(capacity) person"
            return
        }
        self.textLabel?.text = "\(capacity) people"
        
        let text = "\(capacity) people"
        self.textLabel?.attributedText = NSMutableAttributedString(string: text, attributes: globalTextAttrs)
    }
    
    func configureCell(with sr: AirServiceRequest) {
        var detailText = ""
        detailText += (sr.timestamp?.localizedDescription ?? "No Time") + " • " + (sr.office?.name ?? "No Office")
        if let note = sr.note {
            detailText += " • "+note
        }
        
        let text = sr.issueType?.title ?? "No Title Provided"
        self.textLabel?.attributedText = NSMutableAttributedString(string: text, attributes: globalTextAttrs)
        self.detailTextLabel?.attributedText = NSMutableAttributedString(string: detailText, attributes: globalTextAttrs)
    }
    
    func configureCell(with section: SettingsTVCSection) {
        
        self.textLabel?.text = section.title ?? "No Title Provided"
        let text = section.title ?? "No Title Provided"
        self.textLabel?.attributedText = NSMutableAttributedString(string: text, attributes: globalTextAttrs)
        self.accessoryType = .disclosureIndicator
    }
    
    func configureCell(with reservation: AirReservation) {
        if let reservation = reservation as? AirConferenceRoomReservation {
            var subtitleString = (reservation.startingDate?.localizedDescription ?? "No Start Date")
            subtitleString += " to "
            subtitleString += (reservation.endDate?.localizedDescriptionNoDate ?? "No End Date")
            self.textLabel?.attributedText = NSMutableAttributedString(string: reservation.conferenceRoom?.name ?? "No Name", attributes: globalTextAttrs)
            self.detailTextLabel?.attributedText = NSMutableAttributedString(string: subtitleString, attributes: globalTextAttrs)
            self.accessoryType = .disclosureIndicator
        } else if let reservation = reservation as? AirDeskReservation {
            return
        }
    }
}

