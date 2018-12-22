//
//  ConferenceRoomTVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

protocol ConferenceRoomTVCellDelegate {
    func didSelectCollectionView(for room: AirConferenceRoom)
}

class ConferenceRoomTVCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var hourSegments = [Date]()
    var hourSegmentsCount = 8
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
    }
    
    func configureCell(with room: AirConferenceRoom, startingAt reservationRangeStartDate: Date?, delegate: ConferenceRoomTVCellDelegate, hourSegmentCount: Int = 8) {
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
        if let amenities = room.amenities {
            let amenitiesStringArr = amenities.map { (amenity) -> String in
                return amenity.description
            }
            let amenitiesString = amenitiesStringArr.joined(separator: " • ")
            subtitleText += amenitiesString
        }
        self.subtitleLabel.text = subtitleText
        self.loadReservationData()
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
        firstDateComponents.setValue(0, for: .minute)
        firstDateComponents.setValue(0, for: .second)
        firstDateComponents.setValue(0, for: .nanosecond)
        if let firstHourDate = Calendar.current.date(from: firstDateComponents) {
            self.hourSegments.append(firstHourDate)
        }
        for _ in 2...hourSegmentsCount {
            if let currentHourCompVal = firstDateComponents.hour {
                firstDateComponents.setValue(currentHourCompVal+1, for: .hour)
                if let date = Calendar.current.date(from: firstDateComponents) {
                    self.hourSegments.append(date)
                }
            }
        }
        
        if let lastHourDate = self.hourSegments.last {
            var endDateComponents =  Calendar.current.dateComponents(in: TimeZone.current, from: lastHourDate)
            if let endHourComponent = endDateComponents.hour  {
                endDateComponents.setValue(endHourComponent+1, for: .hour)
                if let endDate = Calendar.current.date(from: endDateComponents) {
                    self.timeRangeEndDate = endDate
                }
            }
        }
        
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
                self.collectionView.reloadData()
            }
        }
    }
}
