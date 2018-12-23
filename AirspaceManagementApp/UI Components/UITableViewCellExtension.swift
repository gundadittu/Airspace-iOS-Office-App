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
        // configure image
        self.textLabel?.text = user.displayName ?? "No name"
        self.detailTextLabel?.text = user.email ?? "No email provided"
        // show proper profile image
        self.imageView?.image = UIImage(named: "user-placeholder")!
    }
    
    func configureCell(with building: AirBuilding) {
        self.accessoryType = .disclosureIndicator
        self.textLabel?.text = building.name ?? "No building name"
        self.detailTextLabel?.text = building.address ?? "No address provided"
        // show proper  image
        self.imageView?.image = UIImage(named: "user-placeholder")!
    }
    
    func configureCell(with company: AirCompany) {
        self.accessoryType = .disclosureIndicator
        self.textLabel?.text = company.name ?? "No company name"
        // self.detailTextLabel?.text = company.address ?? "No address provided"
        // show proper  image
        self.imageView?.image = UIImage(named: "user-placeholder")!
    }
    
    func configureCell(with office: AirOffice) {
        self.accessoryType = .disclosureIndicator
        self.textLabel?.text = office.name ?? "No office name"
        self.detailTextLabel?.text = office.building?.name ?? "No building name provided"
        // show proper  image
        self.imageView?.image = UIImage(named: "user-placeholder")!
    }
    
    func configureCell(with guest: AirGuestRegistration) {
        self.textLabel?.text = guest.guestName ?? "No guest name"
        self.detailTextLabel?.text = (guest.expectedVisitDate?.localizedDescription ?? "No visiting date")+" at "+(guest.visitingOffice?.name ?? "No visiting office")
    }
    
    func configureCell(with notification: AirNotification) {
        self.textLabel?.text = "Title"
        self.detailTextLabel?.text = "Subtitle"
        self.imageView?.image = UIImage(named: "serv-req-icon")
    }

    
    func configureCell(with srType: ServiceRequestTypeItem) {
        self.textLabel?.text = srType.title
    }
    
    func configureCell(with duration: Duration) {
        self.textLabel?.text = duration.description
    }
    
    func configureCell(with amenity: RoomAmenity, selected: Bool) {
        self.textLabel?.text = amenity.description
        self.accessoryType = (selected == true) ? .checkmark : .none
    }
    
    
    func configureCell(with capacity: Int) {
        if capacity == 0 || capacity == 1 {
            self.textLabel?.text = "\(capacity) person"
            return
        }
        self.textLabel?.text = "\(capacity) people"
    }
    
    func configureCell(with sr: AirServiceRequest) {
        self.textLabel?.text = sr.issueType?.title ?? "No Title Provided"
        var detailText = ""
        detailText += (sr.timestamp?.localizedDescription ?? "No Time") + " • " + (sr.office?.name ?? "No Office")
        if let note = sr.note {
            detailText += " • "+note
        }
        self.detailTextLabel?.text = detailText
    }
}

