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
    static let staticTopOffset = CGFloat(30)
    let topOffset = staticTopOffset
    var selectedTimeSlotView: UIView?
    var allReservations = [AirConferenceRoomReservation]()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.0
        self.backgroundImage.image = UIImage(named: "hourCellBackground")
    }
    
    public func configure(with date: Date, with reservations: [AirConferenceRoomReservation]) {
        self.startingDate = date
        self.endingDate = date.addingTimeInterval(TimeInterval(3600))
       
        self.setTitleLabelForCell(with: date)
        
        self.setExistingReservations(with: reservations)
    }
    
    public func setTitleLabelForCell(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: date)
        self.titleLabel.text = dateString
    }
    
    public func setExistingReservations(with reservations: [AirConferenceRoomReservation]) {
        self.allReservations = reservations
        for reservation in reservations {
            guard let resStartDate = reservation.startingDate,
            let resEndDate = reservation.endDate,
            let startDate = self.startingDate,
                let endDate = self.endingDate else {
                    break
            }
            var difference = 0
            var startPoint = CGFloat(0)
            if ((resStartDate < startDate && resEndDate < startDate) || (resStartDate > endDate && resEndDate > endDate)) {
                // reservation does not fall in time range
//                createPanGestureRecognizer(targetView: self.contentView)
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
            
            view.tag = 2
            view.addSubview(imageView)
            self.addSubview(view)
        }
    }
    
    public func getDate(from point: CGPoint, in view: UIView) -> Date? {
        guard let startingDate = self.startingDate else { return nil }
        let convertedPoint = view.convert(point, to: self.contentView)
        let convertedPointX = convertedPoint.x
        let differenceProportion = convertedPointX  / self.frame.width
        let difference = differenceProportion * 60
        var startingDateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: startingDate)
        let newMinuteCount = (startingDateComponents.minute ?? 0)  + Int(difference)
        startingDateComponents.setValue(newMinuteCount, for: .minute)
        let date = startingDateComponents.date
        return date
    }
    
    public func reservation(at point: CGPoint, in view: UIView) -> Bool{
        if let date = self.getDate(from: point, in: view) {
            let mappedAllReservations = self.allReservations.map { (reservation) -> DateInterval in
                guard let resStartDate = reservation.startingDate,
                    let resEndDate = reservation.endDate else { return DateInterval() }
                return DateInterval(start: resStartDate, end: resEndDate)
            }
            for interval in mappedAllReservations {
                if interval.contains(date) {
                    return false
                }
            }
            return true
        }
        return false
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        for view in self.subviews where view.tag == 2 {
            view.removeFromSuperview()
        }
    }
}
