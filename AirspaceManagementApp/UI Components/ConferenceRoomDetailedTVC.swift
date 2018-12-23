//
//  ConferenceRoomDetailedTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/21/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
//import ChameleonFramework

protocol ConferenceRoomDetailedTVCDelegate {
    func didTapWhenDateButton()
    func startLoadingIndicator()
    func stopLoadingIndicator()
    func didChooseNewDates(start: Date, end: Date)
}

class ConferenceRoomDetailedTVC: UITableViewCell {

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var whenDateBtn: UIButton!
    
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var secondSubtitleLabel: UILabel!
    var hourSegments = [Date]()
    var hourSegmentsCount = 24 // one whole day
    var reservations = [AirConferenceRoomReservation]()
    var conferenceRoom: AirConferenceRoom?
    var timeRangeStartDate = Date()
    var timeRangeEndDate = Date()
    var delegate: ConferenceRoomDetailedTVCDelegate?
    var selectedTimeSlotView: UIView?
    var topOffset = CGFloat(30)
    var newResStartDate: Date?
    var newResEndDate: Date?

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
        
//        self.collectionView.backgroundColor = UIColor.flatWhite.lighten(byPercentage: CGFloat(50))
        
        self.topOffset = HourBookingCVC.staticTopOffset

        self.whenDateBtn.setTitleColor(globalColor, for: .normal)
            self.clearBtn.setTitleColor(globalColor, for: .normal)
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bannerImage.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        self.bannerImage.layer.mask = gradient
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ConferenceRoomDetailedTVC.handleLongPressGesture(_:)))
        longPressGestureRecognizer.name = "longPress"
        longPressGestureRecognizer.cancelsTouchesInView = false
        longPressGestureRecognizer.minimumPressDuration = 0.5
        longPressGestureRecognizer.delegate = self
        self.collectionView.addGestureRecognizer(longPressGestureRecognizer)
        
        self.updateReservationTimeFrame()
    }
    
    @IBAction func didTapWhenDateBtn(_ sender: Any) {
        self.delegate?.didTapWhenDateButton()
    }
    
    @IBAction func didTapClearBtn(_ sender: Any) {
        self.clearNewResData()
    }
    
    func setDelegate(with delegate: ConferenceRoomDetailedTVCDelegate) {
        self.delegate = delegate
    }
    
    func configureCell(with room: AirConferenceRoom, for date: Date) {
        var reservationRangeStartDateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: date)
        reservationRangeStartDateComponents.setValue(0, for: .hour)
        reservationRangeStartDateComponents.setValue(0, for: .minute)
        reservationRangeStartDateComponents.setValue(0, for: .second)
        reservationRangeStartDateComponents.setValue(0, for: .nanosecond)
        if let reservationRangeStartDate = reservationRangeStartDateComponents.date {
            let reservationRangeEndDate = reservationRangeStartDate.addingTimeInterval(TimeInterval(60*60*24))
            self.timeRangeStartDate = reservationRangeStartDate
            self.timeRangeEndDate = reservationRangeEndDate
        }
        
        self.whenDateBtn.setTitle(date.localizedMedDateDescription, for: .normal)
        
        self.populateHourSegmentsAndDates(with: date)
        
        self.conferenceRoom = room
        
        if let image = room.image {
            self.bannerImage.image = image
        }
        
        self.clearNewResData()
        
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
}

extension ConferenceRoomDetailedTVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourSegmentsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourBookingCVC", for: indexPath) as? HourBookingCVC else {
            return UICollectionViewCell()
        }
        cell.configure(with: self.hourSegments[indexPath.row], with: self.reservations)
        
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
                self.collectionView.reloadData()
            }
        }
    }
}

extension ConferenceRoomDetailedTVC {
    
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
        let viewWidth = self.bannerImage.frame.width/3
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
    
    @objc func clearNewResData() {
        self.collectionView.viewWithTag(1)?.removeFromSuperview()
        self.selectedTimeSlotView = nil
        self.newResStartDate = nil
        self.newResEndDate = nil
        self.updateDateLabel()
        self.collectionView.isScrollEnabled = true
        self.collectionView.reloadData()
    }
    
    func updateDateLabel() {
        guard let start = self.newResStartDate,
            let end = self.newResEndDate else {
                self.dateLabel.text = "Long press a time to create a reservation"
                self.clearBtn.isHidden = true
                return
        }
        self.clearBtn.isHidden = false
        self.dateLabel.text = start.localizedShortTimeDescription+" to "+end.localizedShortTimeDescription
    }
    
    func addNewReservationRangeView(at startPoint: CGPoint, to endPoint: CGPoint) {
       
        guard selectedTimeSlotView == nil else { return }
        let view = UIView()
        let viewWidth = endPoint.x - startPoint.x
        view.frame = CGRect(x: startPoint.x, y: topOffset, width: viewWidth, height: self.collectionView.frame.height-topOffset)
        view.backgroundColor = globalColor
        view.tag = 1
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 4
        
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: view.frame.width/2, height: view.frame.height)
        
        //        let leftCircle = UIView()
        //        leftCircle.center = CGPoint(x: 0, y: leftView.frame.midY)
        //        leftCircle.frame.size.width = CGFloat(20)
        //        leftCircle.frame.size.height = CGFloat(20)
        //        leftCircle.backgroundColor = .white
        //        leftCircle.layer.borderColor = globalColor.cgColor
        //        leftCircle.layer.borderWidth = CGFloat(3)
        //        leftCircle.layer.cornerRadius = leftCircle.frame.width/2
        //        leftView.addSubview(leftCircle)
        
        let rightView = UIView()
        rightView.frame = CGRect(x: view.frame.width/2, y: 0, width: view.frame.width/2, height: view.frame.height)
        
        //        let rightCircle = UIView()
        //        rightCircle.center = CGPoint(x: rightView.frame.maxX, y: rightView.frame.midY)
        //        rightCircle.frame.size.width = CGFloat(20)
        //        rightCircle.frame.size.height = CGFloat(20)
        //        rightCircle.backgroundColor = .white
        //        rightCircle.layer.borderColor = globalColor.cgColor
        //        rightCircle.layer.borderWidth = CGFloat(3)
        //        rightCircle.layer.cornerRadius = rightCircle.frame.width/2
        //        rightView.addSubview(rightCircle)
        
        let panGestureRecognizerLeft = UIPanGestureRecognizer(target: self, action: #selector(ConferenceRoomDetailedTVC.handlePanGesture(_:)))
        panGestureRecognizerLeft.cancelsTouchesInView = false
        panGestureRecognizerLeft.delegate = self
        panGestureRecognizerLeft.name = "left"
        leftView.addGestureRecognizer(panGestureRecognizerLeft)
        
        let panGestureRecognizerRight = UIPanGestureRecognizer(target: self, action: #selector(ConferenceRoomDetailedTVC.handlePanGesture(_:)))
        panGestureRecognizerRight.cancelsTouchesInView = false
        panGestureRecognizerRight.delegate = self
        panGestureRecognizerRight.name = "right"
        rightView.addGestureRecognizer(panGestureRecognizerRight)
        
        //        let rect = CGRect(x: 0, y: 0, width: view.layer.frame.width, height: view.layer.frame.height)
        //        let imageView = UIImageView(frame: rect)
        //        imageView.image = UIImage(named: "selectedTimeSlot")
        
        //        view.isExclusiveTouch = true
        //        view.addSubview(imageView)
        
        view.addSubview(leftView)
        view.addSubview(rightView)
        view.bringSubviewToFront(leftView)
        view.bringSubviewToFront(rightView)
        
        view.alpha = 0
        self.collectionView.addSubview(view)
        UIView.animate(withDuration: 0.5) {
            view.alpha = 1
        }
        
        self.selectedTimeSlotView = view
        self.updateReservationTimeFrame()
        self.collectionView.isScrollEnabled = false
    }
    
    @objc func handleLongPressGesture(_ longPressGesture: UILongPressGestureRecognizer) {
        let startLocation = longPressGesture.location(in: self.collectionView)
        let endLocation = CGPoint(x: startLocation.x+initialTimeSlotViewWidth, y: startLocation.y)
        self.addNewReservationRangeView(at: startLocation, to: endLocation)
    }
    
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        guard let selectedTimeSlotView = self.selectedTimeSlotView else { return }
        let translation = panGesture.translation(in: self.collectionView)
        panGesture.setTranslation(CGPoint.zero, in: self.collectionView)
        let animationDuration = TimeInterval(0.7)
        
        if panGesture.name == "right" {
            if panGesture.state == .began || panGesture.state == .changed {
                if let view = self.collectionView.viewWithTag(1) {
                    let currentFrame = view.frame
                    let xTrans = translation.x
                    if (xTrans < 0) {
                        let newWidth = currentFrame.width + translation.x // subtracts
                        let newHeight = self.collectionView.frame.height-self.topOffset
                        let newFrame = CGRect(x: currentFrame.minX, y: self.topOffset, width: newWidth, height: newHeight)
                        if (currentFrame.minX + newWidth) < (selectedTimeSlotView.frame.minX + ConferenceRoomDetailedTVC.staticMinimumTimeSlotViewWidth) {
                            return
                        }
                        view.animateTo(frame: newFrame, withDuration: animationDuration)
                    } else {
                        let newWidth = currentFrame.width + translation.x
                        let newHeight = self.collectionView.frame.height-self.topOffset
                        let newFrame = CGRect(x: currentFrame.minX, y: self.topOffset, width: newWidth, height: newHeight)
                        if (currentFrame.minX + newWidth) < (selectedTimeSlotView.frame.minX + ConferenceRoomDetailedTVC.staticMinimumTimeSlotViewWidth) {
                            return
                        }
                        if ((currentFrame.minX + newWidth) > self.collectionView.frame.width),
                            let indexPath = self.collectionView.indexPathForItem(at: CGPoint(x: (currentFrame.minX + newWidth), y: newHeight)),
                            (indexPath.row != (hourSegments.count-1)) {
                            let newIndexPath = IndexPath(row: indexPath.row+1, section: indexPath.section)
                            self.collectionView.isScrollEnabled = true
                            self.collectionView.scrollToItem(at: newIndexPath, at: .right, animated: true)
                            self.collectionView.isScrollEnabled = false
                        }
                        view.animateTo(frame: newFrame, withDuration: animationDuration)
                    }
                    self.updateReservationTimeFrame()
                }
            }
            if panGesture.state == .ended {
                self.updateReservationTimeFrame()
            }
        }
        
        if panGesture.name == "left" {
            if panGesture.state == .began || panGesture.state == .changed {
                if let view = self.collectionView.viewWithTag(1) {
                    let currentFrame = view.frame
                    let xTrans = translation.x
                    if (xTrans < 0) {
                        let newXPos = currentFrame.minX + xTrans // subtracts
                        let newWidth = abs(xTrans) + currentFrame.width
                        let newHeight = self.collectionView.frame.height-self.topOffset
                        let newFrame = CGRect(x: newXPos, y: self.topOffset, width: newWidth, height: newHeight)
                        if newXPos > (selectedTimeSlotView.frame.maxX - ConferenceRoomDetailedTVC.staticMinimumTimeSlotViewWidth) {
                            return
                        }

                        if ((self.collectionView.frame.width-currentFrame.width)+newWidth) > self.collectionView.frame.width,
                            let indexPath = self.collectionView.indexPathForItem(at: CGPoint(x: newXPos, y: newHeight)),
                            (indexPath.row != 0) {
                            let newIndexPath = IndexPath(row: indexPath.row-1, section: indexPath.section)
                            self.collectionView.isScrollEnabled = true
                            self.collectionView.scrollToItem(at: newIndexPath, at: .left, animated: true)
                            self.collectionView.isScrollEnabled = false
                        }
                        view.animateTo(frame: newFrame, withDuration: animationDuration)
                    } else {
                        let newWidth = currentFrame.width - xTrans
                        let newHeight = self.collectionView.frame.height-self.topOffset
                        let newXPos = currentFrame.minX + xTrans
                        let newFrame = CGRect(x: newXPos, y: self.topOffset, width: newWidth, height: newHeight)
                        if newXPos > (selectedTimeSlotView.frame.maxX - ConferenceRoomDetailedTVC.staticMinimumTimeSlotViewWidth) {
                            return
                        }
                        view.animateTo(frame: newFrame, withDuration: animationDuration)
                    }
                    self.updateReservationTimeFrame()
                }
            }
        }
    }
    
    func updateReservationTimeFrame() {
        guard let view = self.selectedTimeSlotView else { return }
        let startTimePosition = CGPoint(x: view.frame.minX, y: view.frame.midY)
        let endTimePosition = CGPoint(x: view.frame.maxX, y: view.frame.midY)
        if let (startCell, endCell) = getCVCellsInFrame(for: view) {
            if let startDate = startCell.getDate(from: startTimePosition, in: collectionView),
                let endDate = endCell.getDate(from: endTimePosition, in: collectionView) {
                self.newResStartDate = startDate
                self.newResEndDate = endDate
                self.delegate?.didChooseNewDates(start: startDate, end: endDate)
                self.updateDateLabel()
            }
        }
    }
    
    func getCVCellsInFrame(for view: UIView) -> (HourBookingCVC, HourBookingCVC)? {
        let startTimePosition = CGPoint(x: view.frame.minX, y: view.frame.midY)
        let endTimePosition = CGPoint(x: view.frame.maxX, y: view.frame.midY)
        if let startIndexPath = self.collectionView.indexPathForItem(at: startTimePosition),
            let endIndexPath = self.collectionView.indexPathForItem(at: endTimePosition), let startCell = self.collectionView.cellForItem(at: startIndexPath) as? HourBookingCVC,
                let endCell = self.collectionView.cellForItem(at: endIndexPath) as? HourBookingCVC {
                return (startCell, endCell)
        }
        return nil
    }
    
    func getCVCellAtPoint(point: CGPoint) -> HourBookingCVC? {
        if let indexPath = self.collectionView.indexPathForItem(at: point),
            let cell = self.collectionView.cellForItem(at: indexPath) as? HourBookingCVC {
            return cell
        }
        return nil
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return shouldAllowGesture(gestureRecognizer)
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return shouldAllowGesture(gestureRecognizer)
    }
    
    func shouldAllowGesture(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let longPressGesture = gestureRecognizer as? UILongPressGestureRecognizer,
            longPressGesture.name == "longPress" {
            let location = longPressGesture.location(in: self.collectionView)
            let centerX = location.x
            let centerY = location.y
            let leftPoint = CGPoint(x: centerX, y: centerY)
            let rightPoint = CGPoint(x: centerX+initialTimeSlotViewWidth, y: centerY)
            
            let view = UIView()
            view.frame = CGRect(x: location.x, y: topOffset, width: self.initialTimeSlotViewWidth, height: self.collectionView.frame.height-topOffset)
            
            if let (leftCell, rightCell)  = self.getCVCellsInFrame(for: view) {
                if leftCell.reservation(at: leftPoint, in: self.collectionView) == false {
                    return false
                }
                if rightCell.reservation(at: rightPoint, in: self.collectionView) == false {
                    return false
                }
                return true 
            } else {
                return false
            }
        } else if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            guard let selectedTimeSlotView = self.selectedTimeSlotView else { return false }
            let translation = panGesture.translation(in: self.collectionView)
            let xTrans = translation.x
            let currentFrame = selectedTimeSlotView.frame
            
            if panGesture.name == "left" {
                if xTrans < 0 {
                    let newXPos = currentFrame.minX + xTrans // subtracts
                    let newYPos = self.collectionView.frame.height-self.topOffset
                    let newPoint = CGPoint(x: newXPos, y: newYPos)
                    if let cell = getCVCellAtPoint(point: newPoint) {
                        return cell.reservation(at: newPoint, in: self.collectionView)
                    } else {
                        return false
                    }
                } else {
                    let newYPos = self.collectionView.frame.height-self.topOffset
                    let newXPos = currentFrame.minX + xTrans
                    let newPoint = CGPoint(x: newXPos, y: newYPos)
                    if let cell = getCVCellAtPoint(point: newPoint) {
                        return cell.reservation(at: newPoint, in: self.collectionView)
                    } else {
                        return false
                    }
                }
            }
            
            if panGesture.name == "right" {
                if xTrans < 0 {
                    let newWidth = currentFrame.width + translation.x // subtracts
                    let newYPos = self.collectionView.frame.height-self.topOffset
                    let newXPos = currentFrame.minX + newWidth
                    let newPoint = CGPoint(x: newXPos, y: newYPos)
                    if let cell = getCVCellAtPoint(point: newPoint) {
                        return cell.reservation(at: newPoint, in: self.collectionView)
                    } else {
                        return false
                    }
                } else {
                    let newWidth = currentFrame.width + translation.x
                    let newXPos = currentFrame.minX + newWidth
                    let newYPos = self.collectionView.frame.height-self.topOffset
                    let newPoint = CGPoint(x: newXPos, y: newYPos)
                    if let cell = getCVCellAtPoint(point: newPoint) {
                        return cell.reservation(at: newPoint, in: self.collectionView)
                    } else {
                        return false
                    }
                }
            }
            // other pan gestures
            return true
        } else {
            // other gestures
            return true
        }
    }
}

extension UIView {
    
    func animateTo(frame: CGRect, withDuration duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        guard let _ = superview else {
            return
        }
        
        let xScale = frame.size.width / self.frame.size.width
        let yScale = frame.size.height / self.frame.size.height
        let x = frame.origin.x + (self.frame.width * xScale)/2
        let y = frame.origin.y + (self.frame.height * yScale)/2
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            self.layer.position = CGPoint(x: x, y: y)
            self.transform = self.transform.scaledBy(x: xScale, y: yScale)
        }, completion: completion)
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
