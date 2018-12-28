//
//  ConferenceRoomDetailedTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/21/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

protocol ConferenceRoomDetailedTVCDelegate {
    func didTapWhenDateButton()
    func didTapStartDateButton()
    func didTapEndDateButton()
    func startLoadingIndicator()
    func stopLoadingIndicator()
    func didChooseNewDates(start: Date, end: Date)
    func didFindConflict()
}

class ConferenceRoomDetailedTVC: UITableViewCell {

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var whenDateBtn: UIButton!
    @IBOutlet weak var secondSubtitleLabel: UILabel!
    
    @IBOutlet weak var selectedStartDateBtn: UIButton!
    
    @IBOutlet weak var selectedEndDateBtn: UIButton!
    
    
    
    var hourSegments = [Date]()
    var hourSegmentsCount = 24 // one whole day
    var reservations = [AirConferenceRoomReservation]()
    var conferenceRoom: AirConferenceRoom?
    var conferenceRoomReservation: AirConferenceRoomReservation?
    var timeRangeStartDate = Date()
    var timeRangeEndDate = Date()
    var delegate: ConferenceRoomDetailedTVCDelegate?
    var selectedTimeSlotView: UIView?
    var topOffset = CGFloat(30)
    var newResStartDate: Date?
    var newResEndDate: Date?
    var currentTimeIndexPath: IndexPath?
    var shouldScrollToMorning = false
    
    static var staticMinimumTimeSlotViewWidth = CGFloat(40)
    static var staticInitialTimeSlotViewWidth = CGFloat(60)
    var initialTimeSlotViewWidth: CGFloat {
        return ConferenceRoomDetailedTVC.staticInitialTimeSlotViewWidth
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(UINib(nibName: "HourBookingCVC", bundle: nil), forCellWithReuseIdentifier: "HourBookingCVC")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.topOffset = HourBookingCVC.staticTopOffset

        self.whenDateBtn.setTitleColor(globalColor, for: .normal)
        self.selectedStartDateBtn.setTitleColor(globalColor, for: .normal)
        self.selectedEndDateBtn.setTitleColor(globalColor, for: .normal)
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bannerImage.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        self.bannerImage.layer.mask = gradient
    }
    
    public func loadCurrentTimeIndexPath() {
        var currentIndex = 0
        for hourSegment in self.hourSegments {
            let dateInterval = DateInterval(start: hourSegment, duration: TimeInterval(3599))
            if dateInterval.contains(Date()) {
                self.currentTimeIndexPath = IndexPath(row: currentIndex, section: 0)
            }
            currentIndex += 1
        }
    }
    
    @IBAction func didTapWhenDateBtn(_ sender: Any) {
        self.delegate?.didTapWhenDateButton()
    }
    @IBAction func didTapStartDateBtn(_ sender: Any) {
        self.delegate?.didTapStartDateButton()
    }
    @IBAction func didTapEndDateBtn(_ sender: Any) {
        self.delegate?.didTapEndDateButton()
    }
    
    
    func setDelegate(with delegate: ConferenceRoomDetailedTVCDelegate) {
        self.delegate = delegate
    }
    
    func configureCell(with room: AirConferenceRoom, for date: Date, newReservationStartDate: Date?, newReservationEndDate: Date?) {
        
        var conflict = false
        if let start = newReservationStartDate,
            let end = newReservationEndDate {
            conflict = self.checkForConflicts(start: start, end: end)
        } else if let start = newReservationStartDate {
            conflict = self.checkDateForConflicts(date: start)
        } else if let end = newReservationEndDate {
            conflict = self.checkDateForConflicts(date: end)
        }
        if (conflict == true) {
            self.delegate?.didFindConflict()
        }
        
        var reservationRangeStartDateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: date)
        reservationRangeStartDateComponents.setValue(0, for: .hour)
        reservationRangeStartDateComponents.setValue(0, for: .minute)
        reservationRangeStartDateComponents.setValue(0, for: .second)
        reservationRangeStartDateComponents.setValue(0, for: .nanosecond)
    
        // sets start time and end time for the time frame that we are trying to display EXISTING reservations for
        if !date.isToday,
            !date.isInRange(date: self.timeRangeStartDate, and: self.timeRangeEndDate) {
            self.shouldScrollToMorning = true
        }

        if let reservationRangeStartDate = reservationRangeStartDateComponents.date {
            let reservationRangeEndDate = reservationRangeStartDate.addingTimeInterval(TimeInterval(60*60*24))
            self.timeRangeStartDate = reservationRangeStartDate
            self.timeRangeEndDate = reservationRangeEndDate
        }
        
        if date.isToday {
            self.whenDateBtn.setTitle("Today", for: .normal)
        } else if date.isTomorrow {
            self.whenDateBtn.setTitle("Tomorrow", for: .normal)
        } else {
            self.whenDateBtn.setTitle(date.localizedMedDateDescription, for: .normal)
        }
        
        self.populateHourSegmentsAndDates(with: date)
        
        if date.isToday {
            self.loadCurrentTimeIndexPath()
        }

        // Remove existing time slot view (given tag 1), so that new one can be configured 
        self.selectedTimeSlotView = nil
        self.collectionView.viewWithTag(1)?.removeFromSuperview()
        
        // set buttons to correct newReservationStartDate and newReservationEndDate
        if let startDate = newReservationStartDate, conflict == false {
            self.newResStartDate = startDate
            self.selectedStartDateBtn.setTitle(startDate.localizedShortTimeDescription, for: .normal)
        } else {
            self.newResStartDate = nil
            self.selectedStartDateBtn.setTitle("Choose", for: .normal)
        }
        if let endDate = newReservationEndDate, conflict == false {
            self.newResEndDate = endDate
            self.selectedEndDateBtn.setTitle(endDate.localizedShortTimeDescription, for: .normal)
        } else {
            self.newResEndDate = nil
            self.selectedEndDateBtn.setTitle("Choose", for: .normal)
        }
    
        
        self.conferenceRoom = room
        
        if let image = room.image {
            self.bannerImage.image = image
        }
        
        self.titleLabel.text = room.name ?? "No Name Provided"
        var subtitleText = ""
        if let offices = room.offices {
            let officesStringArr = offices.map { (office) -> String in
                return office.name ?? "No office name"
            }
            subtitleText += officesStringArr.joined(separator: ", ")
        }
        if let address = room.address {
            let splitAddress = address.split(separator: ",")
            subtitleText += " • "
            subtitleText += String(splitAddress.first ?? "")
        }
        
        var secondSubtitleText = ""
        if let capacity = room.capacity {
            secondSubtitleText += "Seats \(capacity) • "
        }
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
}

extension ConferenceRoomDetailedTVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let newResStartDate = self.newResStartDate,
            let newResEndDate = self.newResEndDate,
            self.selectedTimeSlotView == nil {
            self.addNewReservationRangeView(at: newResStartDate, to: newResEndDate)
        }
        
        if !self.timeRangeStartDate.isToday,
            self.shouldScrollToMorning == true {
            self.shouldScrollToMorning = false
            self.collectionView.scrollToItem(at: IndexPath(row: 7, section: 0), at: .left, animated: true)
        } else if let currentTimeIndexPath = self.currentTimeIndexPath {
            var row = 0
            while (row < currentTimeIndexPath.row) {
                self.collectionView.scrollToItem(at: IndexPath(row: row, section: 0), at: .left, animated: false)
                row = row+2
            }
            self.currentTimeIndexPath = nil
            self.collectionView.scrollToItem(at: currentTimeIndexPath, at: .left, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hourSegments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourBookingCVC", for: indexPath) as? HourBookingCVC else {
            return UICollectionViewCell()
        }
        cell.configure(with: self.hourSegments[indexPath.row], with: self.reservations)
        let interval = DateInterval(start: cell.startingDate!, end: cell.endingDate!)
        if interval.contains(Date()) {
            cell.titleLabel.textColor = globalColor
            self.currentTimeIndexPath = indexPath
        }
        
        // Ensures that the selectedTimeSlotView's minimum width translates to 15 minutes
        let cellWidth = cell.frame.width
        let initialWidth = (cellWidth/60)*15
        
        ConferenceRoomDetailedTVC.staticMinimumTimeSlotViewWidth = initialWidth
        
        return cell
    }
}

extension ConferenceRoomDetailedTVC: UICollectionViewDelegateFlowLayout{
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

extension ConferenceRoomDetailedTVC {
    
    func populateHourSegmentsAndDates(with startDate: Date?) {
        let firstDate = startDate ?? Date()
        var firstDateComponents =  Calendar.current.dateComponents(in: TimeZone.current, from: firstDate)
        firstDateComponents.setValue(0, for: .hour)
        firstDateComponents.setValue(0, for: .minute)
        firstDateComponents.setValue(0, for: .second)
        firstDateComponents.setValue(0, for: .nanosecond)
        
        var localHourSegments = [Date]()
        if let firstHourDate = Calendar.current.date(from: firstDateComponents) {
            localHourSegments.append(firstHourDate)
        }
        
        for _ in 2...self.hourSegmentsCount {
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
        self.delegate?.startLoadingIndicator()
        guard let roomUID = self.conferenceRoom?.uid else { return }
        ReservationManager.shared.getReservationsForConferenceRoom(startDate: timeRangeStartDate, endDate: timeRangeEndDate, conferenceRoomUID: roomUID) { (reservations, error) in
            self.delegate?.stopLoadingIndicator()
            if let _ = error {
                // handle error
                return
            } else if let reservations = reservations {
                self.reservations = reservations
                self.addColorStatusBar()
                // handle any conflicts now with new reservation data
                if let start = self.newResStartDate, let end = self.newResEndDate {
                    if self.checkForConflicts(start: start, end: end) == true,
                        let room = self.conferenceRoom {
                       self.configureCell(with:room, for: self.timeRangeStartDate, newReservationStartDate: start, newReservationEndDate: end)
                    }
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    // return false if no conflicts
    func checkForConflicts(start: Date, end: Date) -> Bool{
        for reservation in self.reservations {
            if let interval = reservation.getDateInterval() {
                if let currRes = self.conferenceRoomReservation,
                    reservation.uid == currRes.uid {
                    continue
                } else {
                    if interval.contains(start) {
                        return true
                    } else if interval.contains(end) {
                        return true
                    } else if ((start < interval.start) && (interval.end < end)) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func checkDateForConflicts(date: Date) -> Bool{
        for reservation in self.reservations {
            if let interval = reservation.getDateInterval() {
                if interval.contains(date) {
                    print(interval)
                    return true
                }
            }
        }
        return false
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
        let attributedString = NSMutableAttributedString(string: string, attributes: globalTextAttrs)
        label.attributedText = attributedString
        view.addSubview(label)
        self.bannerImage.addSubview(view)
    }
    
    func addNewReservationRangeView(at startDate: Date, to endDate: Date) {

        var startDateCellIndex: Int?
        var endDatecellIndex: Int?
        for i in 0..<self.hourSegments.count {
            let interval = DateInterval(start: self.hourSegments[i], duration: TimeInterval(3599))
            if interval.contains(startDate) {
                startDateCellIndex = i
            }
            if interval.contains(endDate) {
                endDatecellIndex = i
            }
        }
        
        if ((startDateCellIndex != nil) && (endDatecellIndex == nil)) {
            endDatecellIndex = (self.hourSegments.count-1)
        } else if ((startDateCellIndex == nil) && (endDatecellIndex != nil)) {
            startDateCellIndex = 0
        }
        
        guard let startIndex = startDateCellIndex,
            let endIndex = endDatecellIndex else {
                return
        }
        
        let startIndexPath = IndexPath(row: startIndex, section: 0)
        let endIndexPath = IndexPath(row: endIndex, section: 0)
        self.collectionView.scrollToItem(at: startIndexPath, at: .left, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            guard let startCell = self.collectionView.cellForItem(at: startIndexPath) as? HourBookingCVC else {
                return
            }
            
            let startPoint = startCell.getPoint(from: startDate, in: self.collectionView)
            if let endCell = self.collectionView.cellForItem(at: endIndexPath) as? HourBookingCVC {
                let endPoint = endCell.getPoint(from: endDate, in: self.collectionView)
                self.addNewReservationRangeView(at: startPoint, to: endPoint)
            } else {
                let cellWidth = startCell.getWidth(in: self.collectionView)
                var totalWidth = CGFloat(0)
                for i in startIndex...endIndex {
                    if (i == startIndex) {
                        totalWidth += startCell.getLengthToEnd(from: startDate, in: self.collectionView)
                    } else if (i == endIndex) {
                        let addedWidth = startCell.getLengthFromOrigin(from: endDate, in: self.collectionView)
                         totalWidth += addedWidth
                    } else {
                        totalWidth += cellWidth
                    }
                }
                let endPoint = CGPoint(x: startPoint.x + totalWidth, y: startPoint.y)
                self.addNewReservationRangeView(at: startPoint, to: endPoint)
            }
        }
    }

    
    func addNewReservationRangeView(at startPoint: CGPoint, to endPoint: CGPoint) {
       
        guard selectedTimeSlotView == nil else {
            return
        }
        let view = UIView()
        let viewWidth = endPoint.x - startPoint.x
        view.frame = CGRect(x: startPoint.x, y: topOffset, width: viewWidth, height: self.collectionView.frame.height-topOffset)
        view.backgroundColor = globalColor
        view.tag = 1
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 4
        view.alpha = 0
        self.collectionView.addSubview(view)
        UIView.animate(withDuration: 0.5) {
            view.alpha = 1
        }
        
        self.selectedTimeSlotView = view
    }
    
    // Code for dragging seletected time frame box over colelction view
    //        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ConferenceRoomDetailedTVC.handleLongPressGesture(_:)))
    //        longPressGestureRecognizer.name = "longPress"
    //        longPressGestureRecognizer.cancelsTouchesInView = false
    //        longPressGestureRecognizer.minimumPressDuration = 0.5
    //        longPressGestureRecognizer.delegate = self
    //        self.collectionView.addGestureRecognizer(longPressGestureRecognizer)
    
    //        self.updateReservationTimeFrame()
    
    //    @objc func clearNewResData() {
    //        self.collectionView.viewWithTag(1)?.removeFromSuperview()
    //        self.selectedTimeSlotView = nil
    //        self.newResStartDate = nil
    //        self.newResEndDate = nil
    //        self.updateDateLabel()
    //        self.collectionView.isScrollEnabled = true
    //        self.collectionView.reloadData()
    //    }
    
    //    func updateDateLabel() {
    //        guard let start = self.newResStartDate,
    //            let end = self.newResEndDate else {
    //                self.dateLabel.text = "Long press a time to create a reservation"
    //                self.clearBtn.isHidden = true
    //                return
    //        }
    //        self.clearBtn.isHidden = false
    //        self.dateLabel.text = start.localizedShortTimeDescription+" to "+end.localizedShortTimeDescription
    //    }
    
//        let leftView = UIView()
//        leftView.frame = CGRect(x: 0, y: 0, width: view.frame.width/2, height: view.frame.height)
        
        //        let leftCircle = UIView()
        //        leftCircle.center = CGPoint(x: 0, y: leftView.frame.midY)
        //        leftCircle.frame.size.width = CGFloat(20)
        //        leftCircle.frame.size.height = CGFloat(20)
        //        leftCircle.backgroundColor = .white
        //        leftCircle.layer.borderColor = globalColor.cgColor
        //        leftCircle.layer.borderWidth = CGFloat(3)
        //        leftCircle.layer.cornerRadius = leftCircle.frame.width/2
        //        leftView.addSubview(leftCircle)
        
//        let rightView = UIView()
//        rightView.frame = CGRect(x: view.frame.width/2, y: 0, width: view.frame.width/2, height: view.frame.height)
        
        //        let rightCircle = UIView()
        //        rightCircle.center = CGPoint(x: rightView.frame.maxX, y: rightView.frame.midY)
        //        rightCircle.frame.size.width = CGFloat(20)
        //        rightCircle.frame.size.height = CGFloat(20)
        //        rightCircle.backgroundColor = .white
        //        rightCircle.layer.borderColor = globalColor.cgColor
        //        rightCircle.layer.borderWidth = CGFloat(3)
        //        rightCircle.layer.cornerRadius = rightCircle.frame.width/2
        //        rightView.addSubview(rightCircle)
        
//        let panGestureRecognizerLeft = UIPanGestureRecognizer(target: self, action: #selector(ConferenceRoomDetailedTVC.handlePanGesture(_:)))
//        panGestureRecognizerLeft.cancelsTouchesInView = false
//        panGestureRecognizerLeft.delegate = self
//        panGestureRecognizerLeft.name = "left"
//        leftView.addGestureRecognizer(panGestureRecognizerLeft)
//
//        let panGestureRecognizerRight = UIPanGestureRecognizer(target: self, action: #selector(ConferenceRoomDetailedTVC.handlePanGesture(_:)))
//        panGestureRecognizerRight.cancelsTouchesInView = false
//        panGestureRecognizerRight.delegate = self
//        panGestureRecognizerRight.name = "right"
//        rightView.addGestureRecognizer(panGestureRecognizerRight)
        
        //        let rect = CGRect(x: 0, y: 0, width: view.layer.frame.width, height: view.layer.frame.height)
        //        let imageView = UIImageView(frame: rect)
        //        imageView.image = UIImage(named: "selectedTimeSlot")
        
        //        view.isExclusiveTouch = true
        //        view.addSubview(imageView)
        
//        view.addSubview(leftView)
//        view.addSubview(rightView)
//        view.bringSubviewToFront(leftView)
//        view.bringSubviewToFront(rightView)
//        self.updateReservationTimeFrame()
//        self.collectionView.isScrollEnabled = false
    }
    
//    @objc func handleLongPressGesture(_ longPressGesture: UILongPressGestureRecognizer) {
//        let startLocation = longPressGesture.location(in: self.collectionView)
//        let endLocation = CGPoint(x: startLocation.x+initialTimeSlotViewWidth, y: startLocation.y)
//        self.addNewReservationRangeView(at: startLocation, to: endLocation)
//    }
//
//    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
//        guard let selectedTimeSlotView = self.selectedTimeSlotView else { return }
//        let translation = panGesture.translation(in: self.collectionView)
//        panGesture.setTranslation(CGPoint.zero, in: self.collectionView)
//        let animationDuration = TimeInterval(0.7)
//
//        if panGesture.name == "right" {
//            if panGesture.state == .began || panGesture.state == .changed {
//                if let view = self.collectionView.viewWithTag(1) {
//                    let currentFrame = view.frame
//                    let xTrans = translation.x
//                    if (xTrans < 0) {
//                        let newWidth = currentFrame.width + translation.x // subtracts
//                        let newHeight = self.collectionView.frame.height-self.topOffset
//                        let newFrame = CGRect(x: currentFrame.minX, y: self.topOffset, width: newWidth, height: newHeight)
//                        if (currentFrame.minX + newWidth) < (selectedTimeSlotView.frame.minX + ConferenceRoomDetailedTVC.staticMinimumTimeSlotViewWidth) {
//                            return
//                        }
//                        view.animateTo(frame: newFrame, withDuration: animationDuration)
//                    } else {
//                        let newWidth = currentFrame.width + translation.x
//                        let newHeight = self.collectionView.frame.height-self.topOffset
//                        let newFrame = CGRect(x: currentFrame.minX, y: self.topOffset, width: newWidth, height: newHeight)
//                        if (currentFrame.minX + newWidth) < (selectedTimeSlotView.frame.minX + ConferenceRoomDetailedTVC.staticMinimumTimeSlotViewWidth) {
//                            return
//                        }
//                        if ((currentFrame.minX + newWidth) > self.collectionView.frame.width),
//                            let indexPath = self.collectionView.indexPathForItem(at: CGPoint(x: (currentFrame.minX + newWidth), y: newHeight)),
//                            (indexPath.row != (hourSegments.count-1)) {
//                            let newIndexPath = IndexPath(row: indexPath.row+1, section: indexPath.section)
//                            self.collectionView.isScrollEnabled = true
//                            self.collectionView.scrollToItem(at: newIndexPath, at: .right, animated: true)
//                            self.collectionView.isScrollEnabled = false
//                        }
//                        view.animateTo(frame: newFrame, withDuration: animationDuration)
//                    }
//                    self.updateReservationTimeFrame()
//                }
//            }
//            if panGesture.state == .ended {
//                self.updateReservationTimeFrame()
//            }
//        }
//
//        if panGesture.name == "left" {
//            if panGesture.state == .began || panGesture.state == .changed {
//                if let view = self.collectionView.viewWithTag(1) {
//                    let currentFrame = view.frame
//                    let xTrans = translation.x
//                    if (xTrans < 0) {
//                        let newXPos = currentFrame.minX + xTrans // subtracts
//                        let newWidth = abs(xTrans) + currentFrame.width
//                        let newHeight = self.collectionView.frame.height-self.topOffset
//                        let newFrame = CGRect(x: newXPos, y: self.topOffset, width: newWidth, height: newHeight)
//                        if newXPos > (selectedTimeSlotView.frame.maxX - ConferenceRoomDetailedTVC.staticMinimumTimeSlotViewWidth) {
//                            return
//                        }
//
//                        if ((self.collectionView.frame.width-currentFrame.width)+newWidth) > self.collectionView.frame.width,
//                            let indexPath = self.collectionView.indexPathForItem(at: CGPoint(x: newXPos, y: newHeight)),
//                            (indexPath.row != 0) {
//                            let newIndexPath = IndexPath(row: indexPath.row-1, section: indexPath.section)
//                            self.collectionView.isScrollEnabled = true
//                            self.collectionView.scrollToItem(at: newIndexPath, at: .left, animated: true)
//                            self.collectionView.isScrollEnabled = false
//                        }
//                        view.animateTo(frame: newFrame, withDuration: animationDuration)
//                    } else {
//                        let newWidth = currentFrame.width - xTrans
//                        let newHeight = self.collectionView.frame.height-self.topOffset
//                        let newXPos = currentFrame.minX + xTrans
//                        let newFrame = CGRect(x: newXPos, y: self.topOffset, width: newWidth, height: newHeight)
//                        if newXPos > (selectedTimeSlotView.frame.maxX - ConferenceRoomDetailedTVC.staticMinimumTimeSlotViewWidth) {
//                            return
//                        }
//                        view.animateTo(frame: newFrame, withDuration: animationDuration)
//                    }
//                    self.updateReservationTimeFrame()
//                }
//            }
//        }
//    }
    
//    func updateReservationTimeFrame() {
//        guard let view = self.selectedTimeSlotView else { return }
//        let startTimePosition = CGPoint(x: view.frame.minX, y: view.frame.midY)
//        let endTimePosition = CGPoint(x: view.frame.maxX, y: view.frame.midY)
//        if let (startCell, endCell) = getCVCellsInFrame(for: view) {
//            if let startDate = startCell.getDate(from: startTimePosition, in: collectionView),
//                let endDate = endCell.getDate(from: endTimePosition, in: collectionView) {
//                self.newResStartDate = startDate
//                self.newResEndDate = endDate
//                self.delegate?.didChooseNewDates(start: startDate, end: endDate)
//                self.updateDateLabel()
//            }
//        }
//    }
//
//    func getCVCellsInFrame(for view: UIView) -> (HourBookingCVC, HourBookingCVC)? {
//        let startTimePosition = CGPoint(x: view.frame.minX, y: view.frame.midY)
//        let endTimePosition = CGPoint(x: view.frame.maxX, y: view.frame.midY)
//        if let startIndexPath = self.collectionView.indexPathForItem(at: startTimePosition),
//            let endIndexPath = self.collectionView.indexPathForItem(at: endTimePosition), let startCell = self.collectionView.cellForItem(at: startIndexPath) as? HourBookingCVC,
//                let endCell = self.collectionView.cellForItem(at: endIndexPath) as? HourBookingCVC {
//                return (startCell, endCell)
//        }
//        return nil
//    }
//
//    func getCVCellAtPoint(point: CGPoint) -> HourBookingCVC? {
//        if let indexPath = self.collectionView.indexPathForItem(at: point),
//            let cell = self.collectionView.cellForItem(at: indexPath) as? HourBookingCVC {
//            return cell
//        }
//        return nil
//    }
//
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return shouldAllowGesture(gestureRecognizer)
//    }
//
//    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        return shouldAllowGesture(gestureRecognizer)
//    }
//
//    func shouldAllowGesture(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if let longPressGesture = gestureRecognizer as? UILongPressGestureRecognizer,
//            longPressGesture.name == "longPress" {
//            let location = longPressGesture.location(in: self.collectionView)
//            let centerX = location.x
//            let centerY = location.y
//            let leftPoint = CGPoint(x: centerX, y: centerY)
//            let rightPoint = CGPoint(x: centerX+initialTimeSlotViewWidth, y: centerY)
//
//            let view = UIView()
//            view.frame = CGRect(x: location.x, y: topOffset, width: self.initialTimeSlotViewWidth, height: self.collectionView.frame.height-topOffset)
//
//            if let (leftCell, rightCell)  = self.getCVCellsInFrame(for: view) {
//                if leftCell.reservation(at: leftPoint, in: self.collectionView) == false {
//                    return false
//                }
//                if rightCell.reservation(at: rightPoint, in: self.collectionView) == false {
//                    return false
//                }
//                return true
//            } else {
//                return false
//            }
//        } else if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
//            guard let selectedTimeSlotView = self.selectedTimeSlotView else { return false }
//            let translation = panGesture.translation(in: self.collectionView)
//            let xTrans = translation.x
//            let currentFrame = selectedTimeSlotView.frame
//
//            if panGesture.name == "left" {
//                if xTrans < 0 {
//                    let newXPos = currentFrame.minX + xTrans // subtracts
//                    let newYPos = self.collectionView.frame.height-self.topOffset
//                    let newPoint = CGPoint(x: newXPos, y: newYPos)
//                    if let cell = getCVCellAtPoint(point: newPoint) {
//                        return cell.reservation(at: newPoint, in: self.collectionView)
//                    } else {
//                        return false
//                    }
//                } else {
//                    let newYPos = self.collectionView.frame.height-self.topOffset
//                    let newXPos = currentFrame.minX + xTrans
//                    let newPoint = CGPoint(x: newXPos, y: newYPos)
//                    if let cell = getCVCellAtPoint(point: newPoint) {
//                        return cell.reservation(at: newPoint, in: self.collectionView)
//                    } else {
//                        return false
//                    }
//                }
//            }
//
//            if panGesture.name == "right" {
//                if xTrans < 0 {
//                    let newWidth = currentFrame.width + translation.x // subtracts
//                    let newYPos = self.collectionView.frame.height-self.topOffset
//                    let newXPos = currentFrame.minX + newWidth
//                    let newPoint = CGPoint(x: newXPos, y: newYPos)
//                    if let cell = getCVCellAtPoint(point: newPoint) {
//                        return cell.reservation(at: newPoint, in: self.collectionView)
//                    } else {
//                        return false
//                    }
//                } else {
//                    let newWidth = currentFrame.width + translation.x
//                    let newXPos = currentFrame.minX + newWidth
//                    let newYPos = self.collectionView.frame.height-self.topOffset
//                    let newPoint = CGPoint(x: newXPos, y: newYPos)
//                    if let cell = getCVCellAtPoint(point: newPoint) {
//                        return cell.reservation(at: newPoint, in: self.collectionView)
//                    } else {
//                        return false
//                    }
//                }
//            }
//            // other pan gestures
//            return true
//        } else {
//            // other gestures
//            return true
//        }
//    }

