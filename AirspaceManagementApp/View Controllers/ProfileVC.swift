//
//  ProfileVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/21/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit

class ProfileVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var sections = [ProfileSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName: "BioTVCell", bundle: nil), forCellReuseIdentifier: "BioTVCell")
        self.tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
        self.tableView.allowsSelection = false
        
        self.sections = [ProfileSection(type: .bioInfo),
                    ProfileSection(type: .myRoomReservations),
                    ProfileSection(type: .myDeskReservations),
                    ProfileSection(type: .myServiceRequests),
                    ProfileSection(type: .myRegisteredGuests)]
    }
}

extension ProfileVC: UITableViewDelegate {
    
}

extension ProfileVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currSection = sections[section]
        switch currSection.type {
        case .myRoomReservations?:
            return "My Room Reservations"
        case .some(.bioInfo):
            return ""
        case .some(.myDeskReservations):
            return "My Desk Reservations"
        case .some(.myServiceRequests):
            return "My Service Requests"
        case .some(.myRegisteredGuests):
            return "My Registered Guests"
        case .none:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(200)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currSection = sections[indexPath.section]
        switch currSection.type {
        case .bioInfo?:
            var cell = BioTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "BioTVCell", for: indexPath) as? BioTVCell  {
                cell = tvCell
            } else {
                tableView.register(UINib(nibName: "BioTVCell", bundle: nil), forCellReuseIdentifier: "BioTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "BioTVCell", for: indexPath) as! BioTVCell
            }
            cell.profileImg.image = UIImage(named: "profile-image")
            cell.mainLbl.text = "John Snow"
            cell.subtitleLbl.text = "johnsnow@winterfell.com"
            return cell
        case .myRoomReservations?:
            var cell = CarouselTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                cell = tvCell
            } else {
                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
            }
            cell.setCarouselItems(with: [CarouselCVCellItem(title: "King's Landing", subtitle: "Today 5 PM to 7 PM", image: UIImage(named: "room-5")!), CarouselCVCellItem(title: "Braavos", subtitle: "Friday 10 AM to 11:30 AM", image: UIImage(named: "room-3")!)])
            return cell
        case .myRegisteredGuests?:
            var cell = CarouselTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                cell = tvCell
            } else {
                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
            }
            cell.setCarouselItems(with: [CarouselCVCellItem(title: "title", subtitle: "subtitle", image: UIImage(named: "room-1")!), CarouselCVCellItem(title: "title", subtitle: "subtitle", image: UIImage(named: "room-2")!)])
            return cell
        case .myDeskReservations?:
            var cell = CarouselTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                cell = tvCell
            } else {
                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
            }
            cell.setCarouselItems(with: [CarouselCVCellItem(title: "HotDesk-7", subtitle: "Today 9 AM to 10 AM", image: UIImage(named: "room-4")!), CarouselCVCellItem(title: "HotDesk-3", subtitle: "Today 2 PM to 5 PM", image: UIImage(named: "room-1")!)])
            return cell
        case .myServiceRequests?:
            var cell = CarouselTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                cell = tvCell
            } else {
                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
            }
            cell.setCarouselItems(with: [CarouselCVCellItem(title: "title", subtitle: "subtitle", image: UIImage(named: "room-2")!), CarouselCVCellItem(title: "title", subtitle: "subtitle", image: UIImage(named: "room-4")!)])
            return cell
        case .none:
            break
        }
        return UITableViewCell()
    }
}
