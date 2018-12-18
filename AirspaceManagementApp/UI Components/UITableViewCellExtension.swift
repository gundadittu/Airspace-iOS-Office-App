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
    
    func configureCell(with user: AirUser) {
        self.accessoryType = .disclosureIndicator
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
        self.detailTextLabel?.text = office.buildingName ?? "No building name provided"
        // show proper  image
        self.imageView?.image = UIImage(named: "user-placeholder")!
    }
    
    func configureCell(with guest: AirGuestRegistration) {
        self.textLabel?.text = guest.guestName ?? "No guest name"
        self.detailTextLabel?.text = (guest.expectedVisitDate?.localizedDescription ?? "No visiting date")+" at "+(guest.visitingOffice?.name ?? "No visiting office")
    }
    
    func configureCell(with srType: ServiceRequestTypeItem) {
        self.textLabel?.text = srType.title
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

