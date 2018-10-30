//
//  NotificationTVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/22/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

class NotificationTVCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    
    func configureCell(notification: UserNotification) {
        self.titleLabel.text = notification.title
        self.bodyLabel.text = notification.body
        self.timeLabel.text = "3h ago"
        var image: UIImage?
        switch notification.type {
        case .buildingAnnouncement?:
            image = UIImage(named: "announcement-icon")!
        case .guestArrival?:
            break
        case .servReqStatusChange?:
            image = UIImage(named: "serv-req-icon")!
        case .serReqAssigned?:
            break
        case .newEvent?:
            break
        case .upcomingEvent?:
            break
        case .unknown?:
            break
        case .none:
            break
        }
        self.cellImage.image = image
        
        self.accessoryType = .disclosureIndicator
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
