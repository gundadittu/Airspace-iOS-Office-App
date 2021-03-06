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
import NotificationBannerSwift
import Firebase

class ReserveVC: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var sections = [ReserveVCSection]()
    var roomSections = [ReserveVCSection(type: .quickReserveRoom), ReserveVCSection(type: .reserveRoom), ReserveVCSection(type: .allRooms)]
    var deskSections = [ReserveVCSection(type: .quickReserveDesk), ReserveVCSection(type: .reserveDesk), ReserveVCSection(type: .allDesks)]
    var timeRangeOptions = [CarouselCVCellItem]()
    var type = ReserveVCConfiguration.conferenceRooms
    var allConferenceRooms = [AirConferenceRoom]()
    var allHotDesks = [AirDesk]()
    var loadingIndicator: NVActivityIndicatorView?
    var allRoomsStartDate = Date()
    var allDesksStartDate = Date()
    var dataController: ReserveVCDataController?
    var didPull = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Reserve"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
        self.tableView.register(UINib(nibName: "SeeMoreTVC", bundle: nil), forCellReuseIdentifier: "SeeMoreTVC")
        self.tableView.register(UINib(nibName: "ConferenceRoomTVCell", bundle: nil), forCellReuseIdentifier: "ConferenceRoomTVCell")
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        
        if self.dataController == nil {
            self.dataController = ReserveVCDataController(delegate: self)
        }
        
        self.tableView.spr_setTextHeader { [weak self] in
            self?.didPull = true
            self?.dataController?.loadData(for: self?.type)
        }
        
        let control = BetterSegmentedControl(
            frame: CGRect(x: 0, y: 0, width: (view.frame.width - CGFloat(20)), height: topView.frame.height),
            segments: LabelSegment.segments(withTitles: ["Conference Rooms", "Hot Desks"],
                                            normalFont: UIFont(name: "Avenir Next", size: 15.0)!,
                                            normalTextColor: .black,
                                            selectedFont: UIFont(name: "Avenir Next", size: 15.0)!,
                                            selectedTextColor: .white),
            index: 0,
            options: [.backgroundColor(.flatWhite),
                      .indicatorViewBackgroundColor(.flatBlack),
                      .cornerRadius(17.0)])
        
        control.addTarget(self, action: #selector(ReserveVC.controlValueChanged(_:)), for: .valueChanged)
        topView.addSubview(control)
        
        self.sections = self.roomSections
        
        let loadingIndicator = getGlobalLoadingIndicator(in: self.view)
        self.loadingIndicator = loadingIndicator
        self.view.addSubview(loadingIndicator)
        
        self.updateQuickReserveTimeRangeOptions()
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
        self.updateQuickReserveTimeRangeOptions()
    }
    
    func updateQuickReserveTimeRangeOptions() {
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
            if let duration = Duration(rawValue: 60) {
                let carouselItem = CarouselCVCellItem(with: duration)
                timeRangeOptionsArr.append(carouselItem)
            }
            if let duration = Duration(rawValue: 240) {
                let carouselItem = CarouselCVCellItem(with: duration)
                timeRangeOptionsArr.append(carouselItem)
            }
            if let duration = Duration(rawValue: 480) {
                let carouselItem = CarouselCVCellItem(with: duration)
                timeRangeOptionsArr.append(carouselItem)
            }
            self.timeRangeOptions = timeRangeOptionsArr
        }
        self.reloadTableView()
    }
}

extension ReserveVC: UITableViewDelegate, UITableViewDataSource {
    
    func reloadTableView(with set: IndexSet? = nil) {
        if let tableView = self.tableView {
            if let set = set {
                tableView.reloadSections(set, with: .automatic)
            } else {
                let set: IndexSet = [0,1,2]
                tableView.reloadSections(set, with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let currSection = self.sections[section]
        guard let type = currSection.type else {
            return CGFloat(0)
        }
        if type == .reserveDesk || type == .reserveRoom {
            return CGFloat(0)
        }
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader") as? TableSectionHeader else {
            return UIView()
        }
        let currSection = sections[section]
        let sectionTitle = currSection.title
        cell.titleLabel.text = sectionTitle
        cell.section = currSection
        cell.chevronBtn.isHidden = true 
        return cell
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
            if indexPath.row == 0 {
                return false 
            }
            break
        case .allDesks:
            if indexPath.row == 0 {
                return false
            }
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
            let room = self.allConferenceRooms[indexPath.row-1]
            self.performSegue(withIdentifier: "toConferenceRoomProfileTVC", sender: room)
        case .allDesks:
            let desk = self.allHotDesks[indexPath.row-1]
            self.performSegue(withIdentifier: "toHotDeskProfileVC", sender: desk)
        }
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
            return (self.allConferenceRooms.count + 1)
        case .some(.allDesks):
            return (self.allHotDesks.count + 1)
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeeMoreTVC") as? SeeMoreTVC else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .reserveDesk:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "SeeMoreTVC") as? SeeMoreTVC else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .allRooms:
            if indexPath.row == 0 {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChooseDateTVCell", for: indexPath) as? ChooseDateCell else {
                    return UITableViewCell()
                }
                cell.setCell(with: self.allRoomsStartDate, and: self)
                return cell
            } else {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ConferenceRoomTVCell", for: indexPath) as? ConferenceRoomTVCell else {
                    return UITableViewCell()
                }
                cell.configureCell(with: self.allConferenceRooms[indexPath.row-1], startingAt: self.allRoomsStartDate, delegate: self)
                return cell
            }
        case .allDesks:
            if indexPath.row == 0 {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChooseDateTVCell", for: indexPath) as? ChooseDateCell else {
                    return UITableViewCell()
                }
                cell.setCell(with: self.allDesksStartDate, and: self)
                return cell
            } else {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ConferenceRoomTVCell", for: indexPath) as? ConferenceRoomTVCell else {
                    return UITableViewCell()
                }
                cell.configureCell(with: self.allHotDesks[indexPath.row-1], startingAt: self.allDesksStartDate, delegate: self)
                return cell
            }
        }
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
            self.performSegue(withIdentifier: "toFindDeskVC", sender: nil)
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
    func descriptionForEmptyState(for identifier: String?) -> String {
        return ""
    }
    
    // Empty state not required, since all FormTVCells on this page contain static content
    func titleForEmptyState(for identifier: String?) -> String {
        return ""
    }
    func imageForEmptyState(for identifier: String?) -> UIImage {
        return UIImage()
    }
    func isLoadingData(for identifier: String?) -> Bool {
        return false
    }
    
    func didSelectCarouselCVCellItem(item: CarouselCVCellItem) {
        // did select a quickReserve cell
        if let duration = item.data as? Duration {
            switch self.type {
            case .conferenceRooms:
                self.performSegue(withIdentifier: "ReserveVCtoFindRoomTVC", sender: duration)
            case .hotDesks:
                self.performSegue(withIdentifier: "toFindDeskVC", sender: duration)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReserveVCtoFindRoomTVC",
            let destination = segue.destination as? FindRoomVC,
            let duration = sender as? Duration {
            let dataController = FindRoomVCDataController(delegate: destination, shouldAutomaticallySubmit: true)
            dataController.selectedDuration = duration
            destination.dataController = dataController
        } else if segue.identifier == "toConferenceRoomProfileTVC",
            let destination = segue.destination as? ConferenceRoomProfileTVC,
            let room = sender as? AirConferenceRoom {
            destination.existingResDisplayStartDate = self.allRoomsStartDate
            destination.conferenceRoom = room
        } else if segue.identifier == "toDateInputVC",
            let destination = segue.destination as? DateTimeInputVC {
            destination.mode = .date
            switch self.type {
            case .conferenceRooms:
                destination.minimumDate = Date()
                destination.initialDate = self.allRoomsStartDate
                destination.delegate = self
            case .hotDesks:
                destination.minimumDate = Date()
                destination.initialDate = self.allDesksStartDate
                destination.delegate = self
            }
        } else if segue.identifier == "toHotDeskProfileVC",
            let destination = segue.destination as? HotDeskProfileVC,
            let desk = sender as? AirDesk {
            destination.existingResDisplayStartDate = self.allDesksStartDate
            destination.hotDesk = desk
        } else if segue.identifier == "toFindDeskVC",
            let destination = segue.destination as? FindDeskVC,
            let duration = sender as? Duration {
            let dataController = FindDeskVCDataController(delegate: destination, shouldAutomaticallySubmit: true)
            dataController.selectedDuration = duration
            destination.dataController = dataController
        }
    }
}

extension ReserveVC: DateTimeInputVCDelegate {
    func didSaveInput(with date: Date, and identifier: String?) {
        switch self.type {
        case .conferenceRooms:
            self.allRoomsStartDate = date
            self.reloadTableView()
        case .hotDesks:
            self.allDesksStartDate = date
            self.reloadTableView()
        }
    }
}

extension ReserveVC: ReserveVCDataControllerDelegate {
    
    func startLoadingIndicator() {
        if self.didPull == true {
            return
        }
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        if self.dataController?.isLoading == false  {
            self.loadingIndicator?.stopAnimating()
        }
    }
    
    func didLoadData(allRooms: [AirConferenceRoom]?, allDesks: [AirDesk]?, with error: Error?) {
        self.didPull = false 
        if let _ = error {
            let banner = NotificationBanner(title: "Zoinks!", subtitle: "We were unable to load your conference rooms and desk. Please try again later.", leftView: nil, rightView: nil, style: .danger, colors: nil)
            banner.show()
        }
        if let allRooms = allRooms {
            self.allConferenceRooms = allRooms
            if self.type == .conferenceRooms {
                self.reloadTableView()
            }
        }
        
        if let allDesks = allDesks {
            self.allHotDesks = allDesks
            if self.type == .hotDesks {
                self.reloadTableView()
            }
        }
        
        if self.dataController?.isLoading == false,
            let tableView = self.tableView {
            tableView.spr_endRefreshing()
        }
    }
    
    
//    func loadData() {
//        switch self.type {
//        case .conferenceRooms:
//            loadAllConferenceRooms()
//        case .hotDesks:
//            loadAllHotDesks()
//        }
//    }
//
//    func loadAllHotDesks() {
//        self.loadingIndicator?.startAnimating()
//        FindDeskManager.shared.getAllHotDesksForUser { (desks, error) in
//            self.tableView.spr_endRefreshing()
//            self.loadingIndicator?.stopAnimating()
//            if let _ = error {
//                return
//            } else if let desks = desks {
//                self.allHotDesks = desks
//                self.reloadTableView()
//            } else {
//                // handle error
//                return
//            }
//        }
//    }
//
//    func loadAllConferenceRooms() {
//        self.loadingIndicator?.startAnimating()
//        FindRoomManager.shared.getAllConferenceRoomsForUser { (rooms, error) in
//            self.tableView.spr_endRefreshing()
//            self.loadingIndicator?.stopAnimating()
//            if let _ = error {
//                return
//            } else if let rooms = rooms {
//                self.allConferenceRooms = rooms
//                self.reloadTableView()
//            } else {
//                // handle error
//                return
//            }
//        }
//    }
}

extension ReserveVC: ConferenceRoomTVCellDelegate {
    // Clicked on a cell in list of ALL desks
    func didSelectCollectionView(for desk: AirDesk) {
         self.performSegue(withIdentifier: "toHotDeskProfileTVC", sender: desk)
    }
    
    // Clicked on a cell in list of ALL rooms
    func didSelectCollectionView(for room: AirConferenceRoom) {
        //perform segue to room profile
        self.performSegue(withIdentifier: "toConferenceRoomProfileTVC", sender: room)
    }
}

extension ReserveVC: ChooseDateCellDelegate {
    func didTapChooseDateButton() {
        self.performSegue(withIdentifier: "toDateInputVC", sender: nil)
    }
}

protocol ChooseDateCellDelegate {
    func didTapChooseDateButton()
}

class ChooseDateCell: UITableViewCell {
    @IBOutlet weak var chooseDateBtn: UIButton!
    var delegate: ChooseDateCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chooseDateBtn.setTitleColor(globalColor, for: .normal)
    }
    public func setCell(with date: Date, and delegate: ChooseDateCellDelegate) {
        if date.isToday {
            self.chooseDateBtn.setTitle("Today", for: .normal)
        } else if date.isTomorrow {
            self.chooseDateBtn.setTitle("Tomorrow", for: .normal)
        } else {
            self.chooseDateBtn.setTitle(date.localizedMedDateDescription, for: .normal)
        }
       
        self.delegate = delegate
    }
    @IBAction func didTapDateBtn(_ sender: Any) {
        self.delegate?.didTapChooseDateButton()
    }
}

extension ReserveVC: TableSectionHeaderDelegate {
    func didSelectSectionHeader(with section: PageSection?) {
       return
    }
}
