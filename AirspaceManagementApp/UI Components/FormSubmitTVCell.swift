//
//  FormSubmitTVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/19/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import SwiftyButton

class FormSubmitTVCell: UITableViewCell {

    @IBOutlet weak var button: FlatButton!
    var sectionObject: PageSection?
    var delegate: FormTVCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.color = globalColor
        button.highlightedColor = globalColor
    }
    
    func configureCell(with object: RegisterGuestVCSection, delegate: FormTVCellDelegate) {
        self.delegate = delegate
        self.sectionObject = object
        self.button.setTitle(object.buttonTitle, for: .normal)
    }
    
    func configureCell(with object: ServiceRequestVCSection, delegate: FormTVCellDelegate) {
        self.delegate = delegate
        self.sectionObject = object
        self.button.setTitle(object.buttonTitle, for: .normal)
    }
    
    func configureCell(with object: FindRoomVCSection, delegate: FormTVCellDelegate) {
        self.delegate = delegate
        self.sectionObject = object
        self.button.setTitle(object.buttonTitle, for: .normal)
    }
    
    func configureCell(with object: ConferenceRoomProfileSection, delegate: FormTVCellDelegate) {
        self.delegate = delegate
        self.sectionObject = object
        self.button.setTitle(object.title, for: .normal)
    }
    
    func configureCell(with object: FindDeskVCSection, delegate: FormTVCellDelegate) {
        self.delegate = delegate
        self.sectionObject = object
        self.button.setTitle(object.buttonTitle, for: .normal)
    }
    
    func configureCell(with object: HotDeskProfileSection, delegate: FormTVCellDelegate) {
        self.delegate = delegate
        self.sectionObject = object
        self.button.setTitle(object.title, for: .normal)
    }
    
    func configureCell(with object: RoomReservationVCSection, delegate: FormTVCellDelegate) {
        self.delegate = delegate
        self.sectionObject = object
        self.button.setTitle(object.title, for: .normal)
        if object.type == .cancelReservation {
            button.color = .flatRed
            button.highlightedColor = .flatRed
        } else {
            button.color = globalColor
            button.highlightedColor = globalColor
        }
    }
    
    func configureCell(with object: DeskReservationVCSection, delegate: FormTVCellDelegate) {
        self.delegate = delegate
        self.sectionObject = object
        self.button.setTitle(object.title, for: .normal)
        if object.type == .cancelReservation {
            button.color = .flatRed
            button.highlightedColor = .flatRed
        } else {
            button.color = globalColor
            button.highlightedColor = globalColor
        }
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        guard let so = self.sectionObject else { return }
        self.delegate?.didSelectCellButton(withObject: so)
    }
    
}
