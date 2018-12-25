//
//  ProfileVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/21/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView

class ProfileVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataController: ProfileVCDataController?
    var upcomingGuests = [AirGuestRegistration]()
    var serviceRequests = [AirServiceRequest]()
    var reservations = [AirConferenceRoomReservation]()
    var loadingIndicator: NVActivityIndicatorView?
    
    var sections = [ProfileSection(title: "Bio", seeMoreTitle: "Edit Bio",type: .bioInfo),
                    ProfileSection(title: "My Reserved Rooms", seeMoreTitle: "See More", type: .myRoomReservations),
                    ProfileSection(title: "My Reserved Desks", seeMoreTitle: "See More", type: .myDeskReservations),
                    ProfileSection(title: "My Service Requests", seeMoreTitle: "See More", type: .myServiceRequests),
                    ProfileSection(title: "My Registered Guests", seeMoreTitle: "See More", type: .myRegisteredGuests)]
    
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
        self.tableView.register(UINib(nibName: "SeeMoreTVC", bundle: nil), forCellReuseIdentifier: "SeeMoreTVC")
        self.tableView.allowsSelection = false
        
        self.dataController = ProfileVCDataController(delegate: self)
        
        self.loadingIndicator = getGLobalLoadingIndicator(in: self.tableView)
        self.view.addSubview(self.loadingIndicator!)
        
        let settings = UIBarButtonItem(image: UIImage(named: "settings-icon"), style: .plain, target: self, action: #selector(ProfileVC.didTapSettings))
        self.navigationItem.rightBarButtonItem  = settings
    }
    
    @objc func didTapSettings() {
        self.performSegue(withIdentifier: "toSettingsTVC", sender: nil)
    }
    
    func showUnregisterGuestAlert(guest: AirGuestRegistration) {
        guard let guestUID = guest.uid else { return }
            let alertController = UIAlertController(title: "Manage Registered Guest: \(guest.guestName ?? "No Guest Name Provided")", message: nil, preferredStyle: .actionSheet)
            let unregisterAction = UIAlertAction(title: "Unregister Guest", style: .destructive) { (action) in
                RegisterGuestManager.shared.cancelRegisteredGuest(registeredGuestUID: guestUID, completionHandler: { (error) in
                    if let _ = error {
                        let banner = NotificationBanner(title: "Oh no!", subtitle: "There was an issue unregistering your guest.", leftView: nil, rightView: nil, style: .danger, colors: nil)
                        banner.show()
                    } else {
                        self.dataController?.loadData()
                    }
                })
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(unregisterAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
    }
}

extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currSection = sections[section]
        return currSection.title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(30)
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if let type = self.sections[indexPath.section].type,
                (type == .myRegisteredGuests || type == .myServiceRequests) {
                return CGFloat(120)
            }
            return CGFloat(200)
        } else if indexPath.row == 1 {
            return CGFloat(90)
        }
        return CGFloat(0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currSection = sections[section]
        guard let type = currSection.type else { return 0 }
        switch type {
        case .bioInfo:
            return 1
        case .myRoomReservations:
            break
        case .myDeskReservations:
            break
        case .myServiceRequests:
            break
        case .myRegisteredGuests:
            break
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currSection = sections[indexPath.section]
        switch currSection.type {
        case .bioInfo?:
            if indexPath.row == 0 {
                var cell = BioTVCell()
                if let tvCell = tableView.dequeueReusableCell(withIdentifier: "BioTVCell", for: indexPath) as? BioTVCell  {
                    cell = tvCell
                } else {
                    tableView.register(UINib(nibName: "BioTVCell", bundle: nil), forCellReuseIdentifier: "BioTVCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "BioTVCell", for: indexPath) as! BioTVCell
                }
                cell.profileImg.image = UIImage(named: "profile-image")
                cell.mainLbl.text = UserAuth.shared.displayName
                cell.subtitleLbl.text = UserAuth.shared.email
                return cell
            }
//            else if indexPath.row == 1 {
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeeMoreTVC", for: indexPath) as? SeeMoreTVC else {
//                    return UITableViewCell()
//                }
//                cell.configureCell(with: currSection, buttonTitle: currSection.seeMoreTitle ?? "More", delegate: self)
//                return cell
//            }
        case .myRoomReservations?:
            if indexPath.row == 0 {
                var cell = CarouselTVCell()
                if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                    cell = tvCell
                } else {
                    tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
                }
                
                var carouselItems = [CarouselCVCellItem]()
                for reservation in self.reservations {
                    let item = CarouselCVCellItem(with: reservation)
                    carouselItems.append(item)
                }
                
                cell.setCarouselItems(with: carouselItems)
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeeMoreTVC", for: indexPath) as? SeeMoreTVC else {
                    return UITableViewCell()
                }
                cell.configureCell(with: currSection, buttonTitle: currSection.seeMoreTitle ?? "More", delegate: self)
                return cell
            }
        case .myRegisteredGuests?:
            if indexPath.row == 0 {
                var cell = CarouselTVCell()
                if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                    cell = tvCell
                } else {
                    tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
                }
                var carouselItems = [CarouselCVCellItem]()
                for guest in self.upcomingGuests {
                    carouselItems.append(CarouselCVCellItem(with: guest))
                }
                cell.setCarouselItems(with: carouselItems)
                cell.delegate = self
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeeMoreTVC", for: indexPath) as? SeeMoreTVC else {
                    return UITableViewCell()
                }
                cell.configureCell(with: currSection, buttonTitle: currSection.seeMoreTitle ?? "More", delegate: self)
                return cell
            }
        case .myDeskReservations?:
            if indexPath.row == 0 {
                var cell = CarouselTVCell()
                if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                    cell = tvCell
                } else {
                    tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
                }
                cell.setCarouselItems(with: [CarouselCVCellItem(title: "HotDesk-7", subtitle: "Today 9 AM to 10 AM", image: UIImage(named: "room-4")!), CarouselCVCellItem(title: "HotDesk-3", subtitle: "Today 2 PM to 5 PM", image: UIImage(named: "room-1")!)])
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeeMoreTVC", for: indexPath) as? SeeMoreTVC else {
                    return UITableViewCell()
                }
                cell.configureCell(with: currSection, buttonTitle: currSection.seeMoreTitle ?? "More", delegate: self)
                return cell
            }
        case .myServiceRequests?:
            
            if indexPath.row == 0 {
                var cell = CarouselTVCell()
                if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                    cell = tvCell
                } else {
                    tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
                }
                var carouselItems = [CarouselCVCellItem]()
                for sr in self.serviceRequests {
                    carouselItems.append(CarouselCVCellItem(with: sr))
                }
                cell.setCarouselItems(with: carouselItems)
                cell.delegate = self
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeeMoreTVC", for: indexPath) as? SeeMoreTVC else {
                    return UITableViewCell()
                }
                cell.configureCell(with: currSection, buttonTitle: currSection.seeMoreTitle ?? "More", delegate: self)
                return cell
            }
            
//            if indexPath.row == 0 {
//            var cell = CarouselTVCell()
//            if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
//                cell = tvCell
//            } else {
//                tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
//                cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
//            }
//
//            cell.setCarouselItems(with: [CarouselCVCellItem(title: "title", subtitle: "subtitle", image: UIImage(named: "room-2")!), CarouselCVCellItem(title: "title", subtitle: "subtitle", image: UIImage(named: "room-4")!)])
//            return cell
//            } else if indexPath.row == 1 {
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeeMoreTVC", for: indexPath) as? SeeMoreTVC else {
//                    return UITableViewCell()
//                }
//                cell.configureCell(with: currSection, buttonTitle: currSection.seeMoreTitle ?? "More", delegate: self)
//                return cell
//            }
        case .none:
            break
        }
        return UITableViewCell()
    }
}

extension ProfileVC: SeeMoreTVCDelegate {
    func didSelectSeeMore(for section: PageSection) {
        guard let section = section as? ProfileSection else { return }
        switch section.type {
        case .none:
            return
        case .some(.bioInfo):
            return
        case .some(.myRoomReservations):
            return
        case .some(.myDeskReservations):
            return
        case .some(.myServiceRequests):
            self.performSegue(withIdentifier: "ProfileVCtoMyServReqTVC", sender: nil)
        case .some(.myRegisteredGuests):
            self.performSegue(withIdentifier: "ProfileVCtoMyGuestRegTVC", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileVCtoMyGuestRegTVC",
            let destination = segue.destination as? MyGuestRegTVC {
            destination.upcomingGuests = self.dataController?.upcomingGuests ?? []
            destination.pastGuests = self.dataController?.pastGuests ?? []
        } else if segue.identifier == "ProfileVCtoMyServReqTVC",
            let destination = segue.destination as? MyServReqTVC {
            if let openSR = self.dataController?.openSR {
                destination.openSR = openSR
            }
            if let pendingSR = self.dataController?.pendingSR {
                destination.pendingSR = pendingSR
            }
            if let closedSR = self.dataController?.closedSR {
                destination.closedSR = closedSR
            }
        }
    }
}

extension ProfileVC: ProfileVCDataControllerDelegate {
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()

    }
    
    func startLoadingIndicator() {
        self.loadingIndicator?.startAnimating()
    }
    
    func didUpdateCarouselData() {
        if let upcomingGuests = self.dataController?.upcomingGuests {
            self.upcomingGuests = upcomingGuests
        }
        if let open = self.dataController?.openSR,
            let pending = self.dataController?.closedSR {
            var array = [AirServiceRequest]()
            array.append(contentsOf: open)
            array.append(contentsOf: pending)
            self.serviceRequests = array
        }
        if let reservations = self.dataController?.reservations {
            self.reservations = reservations
        }
        
        self.tableView.reloadData()
    }
}

extension ProfileVC: CarouselTVCellDelegate {
    func didSelectCarouselCVCellItem(item: CarouselCVCellItem) {
        if let guest = item.data as? AirGuestRegistration {
            self.showUnregisterGuestAlert(guest: guest)
        }
    }
}
