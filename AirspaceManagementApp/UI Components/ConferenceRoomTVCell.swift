//
//  ConferenceRoomTVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import ChameleonFramework

protocol ConferenceRoomTVCellDelegate {
    func didSelectCollectionView(for room: AirConferenceRoom)
}

class ConferenceRoomTVCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var secondSubtitleLabel: UILabel!
    
    var hourSegments = [Date]()
    var hourSegmentsCount = 12
    var reservations = [AirConferenceRoomReservation]()
    var conferenceRoom: AirConferenceRoom?
    var timeRangeStartDate = Date()
    var timeRangeEndDate = Date()
    var delegate: ConferenceRoomTVCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(UINib(nibName: "HourBookingCVC", bundle: nil), forCellWithReuseIdentifier: "HourBookingCVC")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bannerImage.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        self.bannerImage.layer.mask = gradient
    }
    
    func configureCell(with room: AirConferenceRoom, startingAt reservationRangeStartDate: Date?, delegate: ConferenceRoomTVCellDelegate, hourSegmentCount: Int = 12) {
        self.delegate = delegate
        self.hourSegmentsCount = hourSegmentCount
        
        self.populateHourSegmentsAndDates(with: reservationRangeStartDate)
        
        self.conferenceRoom = room
        
        if let image = room.image {
            self.bannerImage.image = image
        }

        self.titleLabel.text = room.name ?? "No Name Provided"
        var subtitleText = ""
        if let capacity = room.capacity {
            subtitleText += "Seats \(capacity) • "
        }
        if let offices = room.offices {
            let officesStringArr = offices.map { (office) -> String in
                return office.name ?? "No office name"
            }
            subtitleText += officesStringArr.joined(separator: ", ")
        }
        var secondSubtitleText = ""
        if let amenities = room.amenities {
            let amenitiesStringArr = amenities.map { (amenity) -> String in
                return amenity.description
            }
            let amenitiesString = amenitiesStringArr.joined(separator: " • ")
            secondSubtitleText += amenitiesString
        }
        self.subtitleLabel.text = subtitleText
        self.secondSubtitleLabel.text = secondSubtitleText
        self.loadReservationData()
    }
    
    func addColorStatusBar() {
        var string = ""
        var backgroundColor = UIColor.flatGreenDark
        var nextStartDate: Date?
        var isBusy = false
        for reservation in reservations {
            if let startDate = reservation.startingDate,
                let endDate = reservation.endDate {
                let dateInterval = DateInterval(start: startDate, end: endDate)
                let currDate = Date()
                if dateInterval.contains(currDate) {
                  string = "Busy till \(endDate.localizedShortTimeDescription)"
                isBusy = true
                  backgroundColor = UIColor.flatRedDark
                }
                if nextStartDate == nil,
                    startDate > Date() {
                        nextStartDate = startDate
                }
            }
        }
        if isBusy == false {
            if let date = nextStartDate {
                 string = "Available till \(date.localizedShortTimeDescription)"
            } else {
                 string = "Available all day"
            }
        }
        let view = UIView()
        let viewWidth = self.bannerImage.frame.width/2
        let viewHeight = self.bannerImage.frame.height/5
        view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: viewWidth, height: viewHeight)
        view.backgroundColor = backgroundColor
        view.roundCorners(corners: UIRectCorner.bottomRight, radius: CGFloat(10))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        label.textColor = .white
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attrs = [NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 15.0)!, NSAttributedString.Key.paragraphStyle: paragraph]
        let attributedString = NSMutableAttributedString(string: string, attributes: attrs)
        label.attributedText = attributedString
        view.addSubview(label)
        self.bannerImage.addSubview(view)
    }
}

extension ConferenceRoomTVCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourSegmentsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourBookingCVC", for: indexPath) as? HourBookingCVC else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: self.hourSegments[indexPath.row], with: self.reservations)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let room = self.conferenceRoom else { return }
        self.delegate?.didSelectCollectionView(for: room)
    }
}

extension ConferenceRoomTVCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.bounds.width/4, height: self.collectionView.bounds.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension ConferenceRoomTVCell {
    
    func populateHourSegmentsAndDates(with startDate: Date?) {
        if let startDate = startDate {
            self.timeRangeStartDate = startDate // = Date() otherwise
        }
        let firstDate = timeRangeStartDate
        var firstDateComponents =  Calendar.current.dateComponents(in: TimeZone.current, from: firstDate)
        if self.timeRangeStartDate.isToday == false {
            firstDateComponents.setValue(0, for: .hour)
        }
        firstDateComponents.setValue(0, for: .minute)
        firstDateComponents.setValue(0, for: .second)
        firstDateComponents.setValue(0, for: .nanosecond)
        
        var localHourSegments = [Date]()
        if let firstHourDate = Calendar.current.date(from: firstDateComponents) {
            localHourSegments.append(firstHourDate)
        }
        for _ in 2...hourSegmentsCount {
            if let currentHourCompVal = firstDateComponents.hour {
                firstDateComponents.setValue(currentHourCompVal+1, for: .hour)
                if let date = Calendar.current.date(from: firstDateComponents) {
                    localHourSegments.append(date)
                }
            }
        }
        
        if let lastHourDate = localHourSegments.last {
            var endDateComponents =  Calendar.current.dateComponents(in: TimeZone.current, from: lastHourDate)
            if let endHourComponent = endDateComponents.hour  {
                endDateComponents.setValue(endHourComponent+1, for: .hour)
                if let endDate = Calendar.current.date(from: endDateComponents) {
                    self.timeRangeEndDate = endDate
                }
            }
        }
        self.hourSegments = localHourSegments
        self.collectionView.reloadData()
    }
    
    func loadReservationData() {
        // add loading indicator
        // add correct parameters below
        guard let roomUID = self.conferenceRoom?.uid else { return }
        ReservationManager.shared.getReservationsForConferenceRoom(startDate: timeRangeStartDate, endDate: timeRangeEndDate, conferenceRoomUID: roomUID) { (reservations, error) in
            if let _ = error {
                // handle error
                return
            } else if let reservations = reservations {
                self.reservations = reservations
                self.addColorStatusBar()
                self.collectionView.reloadData()
            }
        }
    }
}
