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
    var allReservations = [AirReservation]()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.0
        self.backgroundImage.image = UIImage(named: "hourCellBackground")
    }
    
    public func configure(with date: Date, with reservations: [AirReservation]) {
        self.startingDate = date
        self.endingDate = date.addingTimeInterval(TimeInterval(3599))
       
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
    
    public func setExistingReservations(with reservations: [AirReservation]) {
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
    
    public func getWidth(in view: UIView) -> CGFloat {
        let convertedRect = self.contentView.convert(self.contentView.frame, to: view)
        let convertedWidth = convertedRect.width
        return convertedWidth
    }
    
    public func getLengthFromOrigin(from date: Date, in view: UIView) -> CGFloat {
        var dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: date)
        let minuteDifference = dateComponents.minute ?? 0
        let proportion =  min(CGFloat(minuteDifference)/CGFloat(60), 1)
        let localXPos = self.contentView.frame.minX + (proportion*self.contentView.frame.width)
        let localWidth = localXPos - self.contentView.frame.minX
        let localRect = CGRect(x: self.contentView.frame.minX, y: self.contentView.frame.midY, width: localWidth, height: self.contentView.frame.height
        )
        let convertedRect = self.contentView.convert(localRect, to: view)
        return convertedRect.width
    }
    
    public func getLengthToEnd(from date: Date, in view: UIView) -> CGFloat {
        var dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: date)
        let minuteDifference = dateComponents.minute ?? 0
        let proportion =  min(CGFloat(minuteDifference)/CGFloat(60), 1)
        let localXPos = self.contentView.frame.minX + (proportion*self.contentView.frame.width)
        let localWidth = self.contentView.frame.maxX - localXPos
        let localRect = CGRect(x: localXPos, y: self.contentView.frame.midY, width: localWidth, height: self.contentView.frame.height)
        return localRect.width
    }
    
    public func getPoint(from date: Date, in view: UIView) -> CGPoint {
        guard let startingDate = self.startingDate, let endingDate = self.endingDate else {
            let convertedRect = self.contentView.convert(self.contentView.frame, to: view)
            let xPoint = convertedRect.minX
            let yPoint = convertedRect.midY
            let convertedPoint = CGPoint(x: xPoint, y: yPoint)
            return convertedPoint
        }
        let currentInterval = DateInterval(start: startingDate, end: endingDate)
        if currentInterval.contains(date) {
            var dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: date)
            let minuteDifference = dateComponents.minute ?? 0
            let proportion =  min(CGFloat(minuteDifference)/CGFloat(60), 1)
            let convertedRect = self.contentView.convert(self.contentView.frame, to: view)
            let xPoint = convertedRect.minX + (proportion*convertedRect.width)
            let yPoint = convertedRect.midY
            let convertedPoint = CGPoint(x: xPoint, y: yPoint)
            return convertedPoint
        } else if (date < startingDate) {
            let convertedRect = self.contentView.convert(self.contentView.frame, to: view)
            let xPoint = convertedRect.minX
            let yPoint = convertedRect.midY
            let convertedPoint = CGPoint(x: xPoint, y: yPoint)
            return convertedPoint
        } else {
            // if date > endingDate
            let convertedRect = self.contentView.convert(self.contentView.frame, to: view)
            let xPoint = convertedRect.maxX
            let yPoint = convertedRect.midY
            let convertedPoint = CGPoint(x: xPoint, y: yPoint)
            return convertedPoint
        }
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
        self.titleLabel.textColor = .black
        for view in self.subviews where view.tag == 2 {
            view.removeFromSuperview()
        }
    }
}
