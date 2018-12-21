//
//  ConferenceRoomTVCell.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

class ConferenceRoomTVCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var hourSegments = [Date]()
    var hourSegmentsCount = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(UINib(nibName: "HourBookingCVC", bundle: nil), forCellWithReuseIdentifier: "HourBookingCVC")
//        self.collectionView.register(nil, forSupplementaryViewOfKind: "none", withReuseIdentifier: "HourBookingCVC")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.minimumInteritemSpacing = CGFloat(0)
//        flowLayout.scrollDirection = .horizontal
//        self.collectionView.collectionViewLayout = flowLayout
        populateHourSegments()
    }
    
    func configureCell(with room: AirConferenceRoom) {
        self.bannerImage.image = UIImage(named: "room-3")
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
        if   let startDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date()),
              let endDate = Calendar.current.date(byAdding: .minute, value: 50, to: Date()),
            let reservation = AirConferenceRoomReservation(startingDate: startDate, endDate: endDate, conferenceRoom: nil) {
            cell.configure(with: self.hourSegments[indexPath.row], with: [reservation])
        }
        return cell
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
    
    func populateHourSegments() {
        let firstDate = Date()
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
        self.collectionView.reloadData()
    }
}
