//
//  NotificationTVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/23/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import SwiftDate

class NotificationTVCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with notification: AirNotification) {
        self.titleLabel.text = notification.title ?? "No title provided"
        self.subtitleLabel.text = notification.body ?? "No body provided"
        self.timeLabel.text = notification.timestamp?.toRelative(style: RelativeFormatter.twitterStyle(), locale: Locales.english) ?? "No time provided"
        
        guard let type = notification.type else { return }
        switch type {
        case .serviceRequestUpdate:
            self.iconImageView.image = UIImage(named: "serv-req-icon")
        case .arrivedGuestUpdate:
            self.iconImageView.image = UIImage(named: "register-guest-icon")
        }
    }

}
