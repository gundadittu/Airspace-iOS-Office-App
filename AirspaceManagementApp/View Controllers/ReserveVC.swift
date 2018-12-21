//
//  ReserveVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/27/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit

class ReserveVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var sections = [ReserveSectionType]()
    var timeRangeOptions: [CarouselCVCellItem] = [CarouselCVCellItem(title: "15", subtitle: nil, image: nil, imageURL: nil, type: .quickReserve), CarouselCVCellItem(title: "30", subtitle: nil, image: nil, imageURL: nil, type: .quickReserve), CarouselCVCellItem(title: "60", subtitle: nil, image: nil, imageURL: nil, type: .quickReserve)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reserve"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
        
        sections = [.quickReserve, .reserveRoom, .reserveDesk, .recentReservations, .onYourFloor]
    }

}

extension ReserveVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currSection = sections[section]
        switch currSection {
        case .quickReserve:
            return "Find a room or desk today for:"
        case .reserveDesk:
            return nil
        case .reserveRoom:
            return nil
        case .recentReservations:
            return "Recently reserved"
        case .freeToday:
            return "Free Today"
        case .onYourFloor:
            return "On Your Floor"
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let section = sections[indexPath.section]
        switch section {
        case .quickReserve:
            return nil
        case .reserveDesk:
            return indexPath
        case .reserveRoom:
            return indexPath
        case .recentReservations:
            return nil
        case .freeToday:
            return nil
        case .onYourFloor:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section {
        case .quickReserve:
           break
        case .reserveDesk:
            break
        case .reserveRoom:
            self.performSegue(withIdentifier: "ReserveVCtoFindRoomTVC", sender: nil)
            break
        case .recentReservations:
            break
        case .freeToday:
            break
        case .onYourFloor:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        switch section {
        case .quickReserve:
            return CGFloat(120)
        case .reserveDesk:
            return CGFloat(60)
        case .reserveRoom:
            return CGFloat(60)
        case .recentReservations:
            return CGFloat(200)
        case .freeToday:
            break
        case .onYourFloor:
            return CGFloat(200)
        }
        return CGFloat(200)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .quickReserve:
            var cell = CarouselTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                cell = tvCell
            } else {
                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
            }
            cell.setCarouselItems(with: self.timeRangeOptions)
            return cell
        case .reserveRoom:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "mainTVCell") as? MainTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = "Reserve a conference room"
            cell.subtitleLabel.isHidden = true
            cell.iconImg.image = UIImage(named: "reserve-icon")
//            cell.iconImg.isHidden = true
            cell.accessoryType = .disclosureIndicator
            return cell
        case .reserveDesk:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "mainTVCell") as? MainTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = "Reserve a hot desk"
            cell.subtitleLabel.isHidden = true
            cell.iconImg.image = UIImage(named: "reserve-icon")
//            cell.iconImg.isHidden = true
            cell.accessoryType = .disclosureIndicator
            return cell
        case .recentReservations:
            var cell = CarouselTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                cell = tvCell
            } else {
                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
            }
            cell.setCarouselItems(with: [CarouselCVCellItem(title: "King's Landing", subtitle: "Seats 10 | Apple TV • Whiteboard • Video Conf.", image: UIImage(named: "room-1")!), CarouselCVCellItem(title: "Braavos", subtitle: "Seats 25 | Apple TV • Whiteboard • Video Conf.", image: UIImage(named: "room-2")!)])
            return cell
        case .freeToday:
            break
        case .onYourFloor:
            var cell = CarouselTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                cell = tvCell
            } else {
                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
            }
            cell.setCarouselItems(with: [CarouselCVCellItem(title: "Volantis", subtitle: "Seats 8 | Apple TV • Whiteboard • Video Conf.", image: UIImage(named: "room-3")!), CarouselCVCellItem(title: "Bay of Dragons", subtitle: "Seats 15 | Apple TV • Whiteboard • Video Conf.", image: UIImage(named: "room-4")!)])
            return cell
        }
        return UITableViewCell()
    }
}
