//
//  HourBookingCVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

class HourBookingCVC: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    var startingDate: Date?
    var endingDate: Date?
    let topOffset = CGFloat(20)

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.0
        self.backgroundImage.image = UIImage(named: "hourCellBackground")
    }
    
    public func configure(with date: Date, with reservations: [AirConferenceRoomReservation]) {
        self.setCellDates(with: date)
        self.setTitleLabelForCell(with: date)
        self.setExistingReservations(with: reservations)
    }
    
    public func setCellDates(with startingDate: Date) {
        self.startingDate = startingDate
        let endDate = startingDate.addingTimeInterval(TimeInterval(3600))
        print(startingDate)
        print(endDate)
        self.endingDate = endDate
    }
    
    public func setTitleLabelForCell(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: date)
        self.titleLabel.text = dateString
    }
    
    public func setExistingReservations(with reservations: [AirConferenceRoomReservation]) {
        // calculate proportion of distance from beg of cell to startTime
        // calculate proportion of distance from end of cell to endTime
        for reservation in reservations {
            guard let resStartDate = reservation.startingDate,
            let resEndDate = reservation.endDate,
            let startDate = self.startingDate,
                let endDate = self.endingDate else { break }
            var difference = 0
            var startPoint = CGFloat(0)
            if ((resStartDate < startDate && resEndDate < startDate) || (resStartDate > endDate && resEndDate > endDate)) {
                // reservation does not fall in time range
                continue
            } else if ((resStartDate < startDate) && (resEndDate > startDate && resEndDate < endDate)) {
                // reservation's startDate not within interval
                difference = resEndDate.minutes(from: startDate)
                startPoint = CGFloat(0)
            } else if ((resEndDate > endDate) && (resStartDate > startDate && resStartDate < endDate)) {
                // reservation's endDate not within interval
                difference = endDate.minutes(from: resStartDate)
                let startingDifference = resStartDate.minutes(from: startDate)
                let startingDifferenceProportion = CGFloat(startingDifference)/60
                startPoint = startingDifferenceProportion * self.frame.width
            } else {
                // reservation within interval
                difference = resEndDate.minutes(from: resStartDate)
                let startingDifference = resStartDate.minutes(from: startDate)
                let startingDifferenceProportion = CGFloat(startingDifference)/60
                startPoint = startingDifferenceProportion * self.frame.width
            }
            
            let proportion = CGFloat(difference)/CGFloat(60)
            let view = UIView()
            view.frame = CGRect(x: startPoint, y: topOffset, width: (proportion*self.frame.width), height: self.frame.height-topOffset)

            let rect = CGRect(x: 0, y: 0, width: view.layer.frame.width, height: view.layer.frame.height)
            let imageView = UIImageView(frame: rect)
            imageView.image = UIImage(named: "reservedSpotBackground")
            view.addSubview(imageView)
            self.addSubview(view)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
    }

}
