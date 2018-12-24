//
//  ReserveVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/27/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import BetterSegmentedControl
import NVActivityIndicatorView
import SwiftPullToRefresh

class ReserveVC: UIViewController {
    
    @IBOutlet weak var topVIew: UIView!
    @IBOutlet weak var tableView: UITableView!
    var sections = [ReserveVCSection]()
    var roomSections = [ReserveVCSection(type: .quickReserveRoom), ReserveVCSection(type: .reserveRoom), ReserveVCSection(type: .allRooms)]
    var deskSections = [ReserveVCSection(type: .quickReserveDesk), ReserveVCSection(type: .reserveDesk), ReserveVCSection(type: .allDesks)]
    var timeRangeOptions = [CarouselCVCellItem]()
    var type = ReserveVCConfiguration.conferenceRooms
    var allConferenceRooms = [AirConferenceRoom]()
    var loadingIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reserve"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
        self.tableView.register(UINib(nibName: "SeeMoreTVC", bundle: nil), forCellReuseIdentifier: "SeeMoreTVC")
        self.tableView.register(UINib(nibName: "ConferenceRoomTVCell", bundle: nil), forCellReuseIdentifier: "ConferenceRoomTVCell")

        self.loadingIndicator = getGLobalLoadingIndicator(in: self.tableView)
        self.tableView.addSubview(self.loadingIndicator!)
        
        self.tableView.spr_setTextHeader { [weak self] in
            self?.loadData()
        }
        
        let control = BetterSegmentedControl(
            frame: CGRect(x: 0, y: 0, width: topVIew.frame.width, height: topVIew.frame.height),
            segments: LabelSegment.segments(withTitles: ["Conference Rooms", "Hot Desks"],
                                            normalFont: UIFont(name: "Avenir Next", size: 15.0)!,
                                            normalTextColor: .black,
                                            selectedFont: UIFont(name: "Avenir Next", size: 15.0)!,
                                            selectedTextColor: .white),
            index: 0,
            options: [.backgroundColor(.flatWhite),
                      .indicatorViewBackgroundColor(globalColor),
                      .cornerRadius(17.0)])
        
        control.addTarget(self, action: #selector(ReserveVC.controlValueChanged(_:)), for: .valueChanged)
        topVIew.addSubview(control)
        self.sections = self.roomSections
        
        self.updateTimeRangeOptions()
        
        self.loadAllConferenceRooms()
    }
    
    @objc func controlValueChanged(_ sender: BetterSegmentedControl) {
        let index = sender.index
        if index == 0 {
            self.sections = self.roomSections
            self.type = .conferenceRooms
        } else if index == 1 {
            self.sections = self.deskSections
            self.type = .hotDesks
        }
        self.updateTimeRangeOptions()
        self.tableView.reloadData()
    }
    
    func updateTimeRangeOptions() {
        switch self.type {
        case .conferenceRooms:
            var timeRangeOptionsArr = [CarouselCVCellItem]()
            if let duration = Duration(rawValue: 15) {
                let carouselItem = CarouselCVCellItem(with: duration)
                timeRangeOptionsArr.append(carouselItem)
            }
            if let duration = Duration(rawValue: 30) {
                let carouselItem = CarouselCVCellItem(with: duration)
                timeRangeOptionsArr.append(carouselItem)
            }
            if let duration = Duration(rawValue: 60) {
                let carouselItem = CarouselCVCellItem(with: duration)
                timeRangeOptionsArr.append(carouselItem)
            }
            self.timeRangeOptions = timeRangeOptionsArr
        case .hotDesks:
            var timeRangeOptionsArr = [CarouselCVCellItem]()
            if let duration = Duration(rawValue: 30) {
                let carouselItem = CarouselCVCellItem(with: duration)
                timeRangeOptionsArr.append(carouselItem)
            }
            if let duration = Duration(rawValue: 120) {
                let carouselItem = CarouselCVCellItem(with: duration)
                timeRangeOptionsArr.append(carouselItem)
            }
            if let duration = Duration(rawValue: 300) {
                let carouselItem = CarouselCVCellItem(with: duration)
                timeRangeOptionsArr.append(carouselItem)
            }
            self.timeRangeOptions = timeRangeOptionsArr
        }
        self.tableView.reloadData()
    }
}

extension ReserveVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let currSectionType = sections[section].type else { return nil }
        switch currSectionType {
        case .quickReserveRoom:
            return "Find a conference room today for:"
        case .reserveDesk:
            return nil
        case .reserveRoom:
            return nil
        case .quickReserveDesk:
            return "Find a hot desk today for:"
        case .allRooms:
            return "All Conference Rooms"
        case .allDesks:
            return "All Hot Desks"
        }
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let currSectionType = sections[indexPath.section].type else { return false }
        switch currSectionType {
        case .quickReserveRoom:
            return false
        case .reserveDesk:
            return false
        case .reserveRoom:
            return false
        case .quickReserveDesk:
            return false
        case .allRooms:
            break
        case .allDesks:
            break
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let currSectionType = sections[indexPath.section].type else { return  }
        switch currSectionType {
        case .quickReserveRoom:
           break
        case .reserveDesk:
            break
        case .reserveRoom:
            break
        case .quickReserveDesk:
            break
        case .allRooms:
            break
        case .allDesks:
             break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let currSectionType = sections[indexPath.section].type else { return CGFloat(0) }
        switch currSectionType {
        case .quickReserveRoom:
            return CGFloat(120)
        case .reserveDesk:
            return CGFloat(100)
        case .reserveRoom:
            return CGFloat(100)
//        case .recentReservations:
//            return CGFloat(200)
//        case .freeToday:
//            break
//        case .onYourFloor:
//            return CGFloat(200)
        case .quickReserveDesk:
            return CGFloat(120)
        case .allRooms:
            return UITableView.automaticDimension
        case .allDesks:
            return UITableView.automaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        switch section.type {
        case .none:
            return 0
        case .some(.quickReserveDesk):
            break
        case .some(.allRooms):
            return self.allConferenceRooms.count
        case .some(.allDesks):
            break
        case .some(.quickReserveRoom):
            break
        case .some(.reserveDesk):
            break
        case .some(.reserveRoom):
            break
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let currSectionType = section.type else { return UITableViewCell() }
        switch currSectionType {
        case .quickReserveRoom:
            var cell = CarouselTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                cell = tvCell
            } else {
                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
            }
            cell.setCarouselItems(with: self.timeRangeOptions)
            cell.delegate = self
            return cell
        case .quickReserveDesk:
            var cell = CarouselTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                cell = tvCell
            } else {
                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
            }
            cell.setCarouselItems(with: self.timeRangeOptions)
            cell.delegate = self
            return cell
        case .reserveRoom:
//            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "mainTVCell") as? MainTableViewCell else {
//                return UITableViewCell()
//            }
//            cell.titleLabel.text = "Reserve a conference room"
//            cell.subtitleLabel.isHidden = true
//            cell.iconImg.image = UIImage(named: "reserve-icon")
////            cell.iconImg.isHidden = true
//            cell.accessoryType = .disclosureIndicator
//            return cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeeMoreTVC") as? SeeMoreTVC else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .reserveDesk:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "SeeMoreTVC") as? SeeMoreTVC else {
                return UITableViewCell()
            }
//            cell.titleLabel.text = "Reserve a hot desk"
//            cell.subtitleLabel.isHidden = true
//            cell.iconImg.image = UIImage(named: "reserve-icon")
////            cell.iconImg.isHidden = true
//            cell.accessoryType = .disclosureIndicator
            cell.configureCell(with: section, delegate: self)
            return cell
//        case .recentReservations:
//            var cell = CarouselTVCell()
//            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
//                cell = tvCell
//            } else {
//                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
//                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
//            }
//            cell.setCarouselItems(with: [CarouselCVCellItem(title: "King's Landing", subtitle: "Seats 10 | Apple TV • Whiteboard • Video Conf.", image: UIImage(named: "room-1")!), CarouselCVCellItem(title: "Braavos", subtitle: "Seats 25 | Apple TV • Whiteboard • Video Conf.", image: UIImage(named: "room-2")!)])
//            return cell
//        case .freeToday:
//            break
//        case .onYourFloor:
//            var cell = CarouselTVCell()
//            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
//                cell = tvCell
//            } else {
//                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
//                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
//            }
//            cell.setCarouselItems(with: [CarouselCVCellItem(title: "Volantis", subtitle: "Seats 8 | Apple TV • Whiteboard • Video Conf.", image: UIImage(named: "room-3")!), CarouselCVCellItem(title: "Bay of Dragons", subtitle: "Seats 15 | Apple TV • Whiteboard • Video Conf.", image: UIImage(named: "room-4")!)])
//            return cell
        case .allRooms:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ConferenceRoomTVCell", for: indexPath) as? ConferenceRoomTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: self.allConferenceRooms[indexPath.row], startingAt: Date(), delegate: self)
            return cell
        case .allDesks:
            break
        }
        return UITableViewCell()
    }
}

extension ReserveVC: SeeMoreTVCDelegate {
    func didSelectSeeMore(for section: PageSection) {
        // clicked reserve conference room/ reserve hot desk button
        guard let section = section as? ReserveVCSection,
            let currSectionType = section.type else { return }
        switch currSectionType {
        case .quickReserveRoom:
            break
        case .quickReserveDesk:
            break
        case .reserveDesk:
            break
        case .reserveRoom:
            self.performSegue(withIdentifier: "ReserveVCtoFindRoomTVC", sender: nil)
        case .allRooms:
            break
        case .allDesks:
            break
        }
    }
}

extension ReserveVC: CarouselTVCellDelegate {
    func didSelectCarouselCVCellItem(item: CarouselCVCellItem) {
        // did select a quickReserve cell
        if let duration = item.data as? Duration {
            switch self.type {
            case .conferenceRooms:
                self.performSegue(withIdentifier: "ReserveVCtoFindRoomTVC", sender: duration)
            case .hotDesks:
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReserveVCtoFindRoomTVC",
            let destination = segue.destination as? FindRoomTVC,
            let duration = sender as? Duration {
            let dataController = FindRoomTVCDataController(delegate: destination)
            dataController.setSelectedDuration(with: duration)
            destination.dataController = dataController
            destination.dataController?.shouldAutomaticallySubmit = true
        }
    }
}

extension ReserveVC {
    
    func loadData() {
        switch self.type {
        case .conferenceRooms:
            loadAllConferenceRooms()
        case .hotDesks:
            break
        }
    }

    func loadAllConferenceRooms() {
        self.loadingIndicator?.startAnimating()
        FindRoomManager.shared.getAllConferenceRoomsForUser { (rooms, error) in
            self.tableView.spr_endRefreshing()
            self.loadingIndicator?.stopAnimating()
            if let error = error {
                // handle error
                return
            } else if let rooms = rooms {
                self.allConferenceRooms = rooms
                self.tableView.reloadData()
            } else {
                // handle error
                return
            }
        }
    }
}

extension ReserveVC: ConferenceRoomTVCellDelegate {
    func didSelectCollectionView(for room: AirConferenceRoom) {
        //perform segue to room profile
        return
    }
}
