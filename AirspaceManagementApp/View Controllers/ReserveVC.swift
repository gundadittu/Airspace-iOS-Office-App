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
        self.tableView.allowsSelection = false
        self.tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
        
        sections = [.quickReserve, .reserve, .recentReservations, .onYourFloor]
    }
}

extension ReserveVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currSection = sections[section]
        if currSection == .quickReserve {
            return "Find a room or desk today for"
        } else if currSection == .reserve {
            return ""
        } else if currSection == .recentReservations {
            return "Recently reserved"
        }  else if currSection == .onYourFloor {
            return "On Your Floor"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        switch section {
        case .quickReserve:
            return CGFloat(120)
        case .reserve:
            return CGFloat(75)
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
        
        if section == .quickReserve {
            var cell = CarouselTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                cell = tvCell
            } else {
                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
            }
            cell.setCarouselItems(with: self.timeRangeOptions)
            return cell
        } else if section == .reserve {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "mainTVCell") as? MainTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = "Reserve a room or desk"
            cell.subtitleLabel.isHidden = true
            cell.iconImg.image = UIImage(named: "reserve-icon")
            cell.accessoryType = .disclosureIndicator
            return cell
        } else if section == .recentReservations {
            var cell = CarouselTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                cell = tvCell
            } else {
                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
            }
            cell.setCarouselItems(with: [CarouselCVCellItem(title: "title", subtitle: "subtitle", image: UIImage(named: "chairs")!), CarouselCVCellItem(title: "title", subtitle: "subtitle", image: UIImage(named: "chairs")!)])
            return cell
        } else if section == .onYourFloor {
            var cell = CarouselTVCell()
            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                cell = tvCell
            } else {
                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
            }
            cell.setCarouselItems(with: [CarouselCVCellItem(title: "title", subtitle: "subtitle", image: UIImage(named: "chairs")!), CarouselCVCellItem(title: "title", subtitle: "subtitle", image: UIImage(named: "chairs")!)])
            return cell
        }
        return UITableViewCell()
    }
}
