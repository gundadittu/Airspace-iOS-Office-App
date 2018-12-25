//
//  SeeMoreTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/21/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

protocol SeeMoreTVCDelegate {
    func didSelectSeeMore(for section: PageSection)
}

class SeeMoreTVC: UITableViewCell {
    var sectionObj: PageSection?
    var delegate: SeeMoreTVCDelegate?
    @IBOutlet weak var button: BorderButton!
    
    func configureCell(with section: ProfileSection, buttonTitle: String, delegate: SeeMoreTVCDelegate) {
        self.sectionObj = section
        self.button.setTitle(buttonTitle, for: .normal)
        self.delegate = delegate
    }
    
    func configureCell(with section: ReserveVCSection, delegate: SeeMoreTVCDelegate) {
        self.sectionObj = section
        self.button.setTitle(section.title, for: .normal)
        self.delegate = delegate
    }
    
    func configureCell(with section: SettingsTVCSection, delegate: SeeMoreTVCDelegate) {
        self.sectionObj = section
        self.button.setTitle(section.title, for: .normal)
        self.delegate = delegate
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        guard let sectionObj = self.sectionObj else { return }
        self.delegate?.didSelectSeeMore(for: sectionObj)
    }
}
