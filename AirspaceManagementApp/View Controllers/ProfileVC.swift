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
import SwiftPullToRefresh
import CFAlertViewController
import WhatsNewKit

class ProfileVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataController: ProfileVCDataController?
    var upcomingGuests = [AirGuestRegistration]()
    var serviceRequests = [AirServiceRequest]()
    var roomReservations = [AirConferenceRoomReservation]()
    var deskReservations = [AirDeskReservation]()
    var loadingIndicator: NVActivityIndicatorView?
    var profileImage: UIImage?
    var imagePicker = UIImagePickerController()

    var sections = [ProfileSection(title: "Bio", seeMoreTitle: "Edit Bio",type: .bioInfo),
                    ProfileSection(title: "My Reserved Rooms", seeMoreTitle: "See More", type: .myRoomReservations),
                    ProfileSection(title: "My Reserved Desks", seeMoreTitle: "See More", type: .myDeskReservations),
                    ProfileSection(title: "My Service Requests", seeMoreTitle: "See More", type: .myServiceRequests),
                    ProfileSection(title: "My Registered Guests", seeMoreTitle: "See More", type: .myRegisteredGuests)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Profile"

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "BioTVCell", bundle: nil), forCellReuseIdentifier: "BioTVCell")
        self.tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        self.tableView.allowsSelection = false
        
        if self.dataController == nil {
            self.dataController = ProfileVCDataController(delegate: self)
        }
        
        let loadingIndicator = getGlobalLoadingIndicator(in: self.view)
        self.loadingIndicator = loadingIndicator
        self.view.addSubview(loadingIndicator)
        
        self.tableView.spr_setTextHeader { [weak self] in
            self?.loadData()
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings")!, style: .plain, target: self, action: #selector(ProfileVC.didTapSave))
        
        self.showOnboarding()
    }
    
    func loadData(){
        self.dataController?.loadData()
    }
    
    @objc func didTapSave() {
        self.performSegue(withIdentifier: "toSettingsTVC", sender: nil)
    }
    
    func showOnboarding() {
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "showProfileOnboarding") == nil {
            defaults.setValue(true, forKey: "showProfileOnboarding")
        } else {
            return
        }
        
        var configuration = WhatsNewViewController.Configuration()
        configuration.backgroundColor = .white
        configuration.titleView.titleColor = globalColor
        configuration.titleView.titleFont = UIFont(name: "AvenirNext-Medium", size: 40)!
        configuration.itemsView.titleFont = UIFont(name: "AvenirNext-Medium", size: 18)!
        configuration.itemsView.subtitleFont = UIFont(name: "AvenirNext-Regular", size: 15)!
        configuration.itemsView.autoTintImage = false
        configuration.completionButton.backgroundColor = globalColor
        configuration.completionButton.titleFont = UIFont(name: "AvenirNext-Medium", size: 18)!
        
        let whatsNew = WhatsNew(
            title: "Your Profile",
            items: [
                WhatsNew.Item(
                    title: "Manage Your Bio",
                    subtitle: "You can add your own profile image by just tapping on your picture. Reach out to your office manager to modify other items.",
                    image: UIImage(named: "bio-icon")
                ),
                WhatsNew.Item(
                    title: "Manage Your Room Reservations",
                    subtitle: "You can see all your conference room reservations here, and update/cancel them.",
                    image: UIImage(named: "reserve-icon")
                ),
                WhatsNew.Item(
                    title: "Manage Your Desk Reservations",
                    subtitle: "You can see all your hot desk reservations here, and update/cancel them.",
                    image: UIImage(named: "table-icon")
                ),
                WhatsNew.Item(
                    title: "Manage Your Service Requests",
                    subtitle: "You can see all your service requests here, and cancel them.",
                    image: UIImage(named: "serv-req-icon")
                ),
                WhatsNew.Item(
                    title: "Manage Your Registered Guests",
                    subtitle: "You can see all your registed guests here, and cancel them.",
                    image: UIImage(named: "register-guest-icon")
                )
            ]
        )
        
        let whatsNewViewController = WhatsNewViewController(
            whatsNew: whatsNew,
            configuration: configuration
        )
        
        self.present(whatsNewViewController, animated: true)
    }
}

extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func reloadTableView(with set: IndexSet? = nil) {
        if let tableView = self.tableView {
            if let set = set {
                tableView.reloadSections(set, with: .automatic)
            } else {
               tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == ((self.sections.count)-1)) {
            return CGFloat(50)
        }
        return CGFloat(20)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view 
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
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
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if let type = self.sections[indexPath.section].type,
                (type == .myRegisteredGuests || type == .myServiceRequests || type == .bioInfo) {
                return CGFloat(140)
            }
            return CGFloat(180)
        return CGFloat(0)
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
                }
                cell.delegate = self
                cell.setProfileImage(with: self.profileImage)
                cell.mainLbl.text = UserAuth.shared.displayName
                cell.subtitleLbl.text = UserAuth.shared.email
                return cell
        case .myRoomReservations?:
                var cell = CarouselTVCell()
                if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                    cell = tvCell
                } else {
                    tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
                }
                
                var carouselItems = [CarouselCVCellItem]()
                for reservation in self.roomReservations {
                    let item = CarouselCVCellItem(with: reservation)
                    carouselItems.append(item)
                }
                
                cell.identifier = "myRoomReservations"
                cell.delegate = self
                cell.setCarouselItems(with: carouselItems)
                return cell
        case .myRegisteredGuests?:
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
                cell.identifier = "myRegisteredGuests"
                cell.delegate = self
                cell.setCarouselItems(with: carouselItems)
                return cell
        case .myDeskReservations?:
                var cell = CarouselTVCell()
                if let tvCell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as? CarouselTVCell  {
                    cell = tvCell
                } else {
                    tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "CarouselTVCell", for: indexPath) as! CarouselTVCell
                }
                cell.identifier = "myDeskReservations"
                cell.delegate = self
                
                var carouselItems = [CarouselCVCellItem]()
                for deskRes in self.deskReservations {
                    let item = CarouselCVCellItem(with: deskRes)
                    carouselItems.append(item)
                }
                
                cell.setCarouselItems(with: carouselItems)
                return cell
        case .myServiceRequests?:
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
                cell.identifier = "myServiceRequests"
                cell.delegate = self
                cell.setCarouselItems(with: carouselItems)
                return cell
        case .none:
            break
        }
        return UITableViewCell()
    }
}

extension ProfileVC {
    
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
        } else if segue.identifier == "toRoomReservationVC",
            let destination = segue.destination as? RoomReservationVC,
            let reservation = sender as? AirConferenceRoomReservation {
            destination.conferenceRoomReservation = reservation
        } else if segue.identifier == "toMyReservationsListTVC",
            let destination = segue.destination as? MyReservationsListTVC,
            let identifier = sender as? String {
            
            if identifier == "conferenceRooms" {
                destination.upcoming = self.dataController?.upcomingReservations ?? []
                destination.past = self.dataController?.pastReservations ?? []
                destination.titleString = "My Room Reservations"
                destination.type = .conferenceRooms
            } else if identifier == "hotDesks" {
                destination.upcoming = self.dataController?.upcomingDeskReservations ?? []
                destination.past = self.dataController?.pastDeskReservations ?? []
                destination.titleString = "My Desk Reservations"
                destination.type = .hotDesks
            }
        } else if segue.identifier == "toDeskReservationVC",
            let destination = segue.destination as? DeskReservationVC,
            let reservation = sender as? AirDeskReservation {
            destination.hotDeskReservation = reservation
        }
    }
}

extension ProfileVC: ProfileVCDataControllerDelegate {
    
    func didFinishUploadingNewImage(with error: Error?) {
        if let _ = error {
            let alertController = CFAlertViewController(title: "Oh no!🤯", message: "There was an issue uploading your new profile picture.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
            
            let action = CFAlertAction(title: "Ok", style: .Default, alignment: .justified, backgroundColor: .red, textColor: .black, handler: nil)
            alertController.addAction(action)
            
            self.present(alertController, animated: true)
        } else {
            let alertController = CFAlertViewController(title: "Rock on!🤟🏼 ", message: "Your profile picture was updated.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
            
            let action = CFAlertAction(title: "Sounds Good", style: .Default, alignment: .justified, backgroundColor: globalColor, textColor: nil, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true)
        }
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
    }
    
    func startLoadingIndicator() {
        self.loadingIndicator?.startAnimating()
    }
    
    func didUpdateCarouselData() {
        if let upcomingGuests = self.dataController?.upcomingGuests {
            self.upcomingGuests = upcomingGuests
            let sectionToReload = 4
            let indexSet: IndexSet = [sectionToReload]
            self.reloadTableView(with: indexSet)
        }
        if let open = self.dataController?.openSR,
            let pending = self.dataController?.closedSR {
            var array = [AirServiceRequest]()
            array.append(contentsOf: open)
            array.append(contentsOf: pending)
            self.serviceRequests = array
            let sectionToReload = 3
            let indexSet: IndexSet = [sectionToReload]
            self.reloadTableView(with: indexSet)
        }
        if let upcomingRes = self.dataController?.upcomingReservations {
            self.roomReservations = upcomingRes
            let sectionToReload = 1
            let indexSet: IndexSet = [sectionToReload]
            self.reloadTableView(with: indexSet)
        }
        if let upcomingDeskRes = self.dataController?.upcomingDeskReservations {
            self.deskReservations = upcomingDeskRes
            let sectionToReload = 2
            let indexSet: IndexSet = [sectionToReload]
            self.reloadTableView(with: indexSet)
        }
        
        if let profileImage = self.dataController?.profileImage {
            self.profileImage = profileImage
            
            let sectionToReload = 0
            let indexSet: IndexSet = [sectionToReload]
            self.reloadTableView(with: indexSet)
        }
        
        
        if (self.dataController?.isLoading == false),
            let tableView = self.tableView {
            tableView.spr_endRefreshing()
        }
    }
}

extension ProfileVC: CarouselTVCellDelegate {
    func descriptionForEmptyState(for identifier: String?) -> String {
        return ""
    }
    
    func titleForEmptyState(for identifier: String?) -> String {

        if identifier == "myServiceRequests" {
            return  "No Active Service Requests"
        } else if identifier == "myDeskReservations" {
               return "No Upcoming Desk Reservations"
        } else if identifier == "myRegisteredGuests" {
            return "No Upcoming Registered Guests"
        } else if identifier == "myRoomReservations" {
            return "No Upcoming Room Reservations"
        }
        return ""
    }
    
    func imageForEmptyState(for identifier: String?) -> UIImage {
        if let identifier = identifier {
            if identifier == "myServiceRequests" {
                return UIImage(named: "no-requests")!
            } else if identifier == "myDeskReservations" {
                return UIImage(named: "no-reservations")!
            } else if identifier == "myRegisteredGuests" {
                return UIImage(named: "no-guests")!
            } else if identifier == "myRoomReservations" {
                return UIImage(named: "no-reservations")!
            }
        }
        return UIImage()
    }
    
    func isLoadingData(for identifier: String?) -> Bool {
        if identifier == "myServiceRequests" {
            return self.dataController?.serviceRequestLoading ?? false
        } else if identifier == "myDeskReservations" {
            return self.dataController?.deskReservationsLoading ?? false
        } else if identifier == "myRegisteredGuests" {
           return self.dataController?.registeredGuestLoading ?? false
        } else if identifier == "myRoomReservations" {
            return self.dataController?.roomReservationsLoading ?? false
        }
        return false
    }
}

extension ProfileVC {
    
    func didSelectCarouselCVCellItem(item: CarouselCVCellItem) {
        if let _ = item.data as? AirGuestRegistration {
            self.performSegue(withIdentifier: "ProfileVCtoMyGuestRegTVC", sender: nil)
        } else if let _ = item.data as? AirServiceRequest {
            self.performSegue(withIdentifier: "ProfileVCtoMyServReqTVC", sender: nil)
        } else if let reservation = item.data as? AirConferenceRoomReservation {
            self.performSegue(withIdentifier: "toRoomReservationVC", sender: reservation)
        } else if let reservation = item.data as? AirDeskReservation {
            self.performSegue(withIdentifier: "toDeskReservationVC", sender: reservation)
        }
    }
    
    func showImagePicker() {
        self.imagePicker.delegate = self
        let alert = UIAlertController(title: "Choose new profile image from:", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            let selectedImage = editedImage
            self.dataController?.uploadNewProfileImage(with: selectedImage)
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            let selectedImage = originalImage
            self.dataController?.uploadNewProfileImage(with: selectedImage)
            picker.dismiss(animated: true, completion: nil)
        } else {
            self.dataController?.uploadNewProfileImage(with: nil)
        }
    }
}

extension ProfileVC: BioTVCellDelegate {
    func didTapImage() {
        self.showImagePicker()
    }
}

extension ProfileVC: TableSectionHeaderDelegate {
    func didSelectSectionHeader(with section: PageSection?) {
        guard let section = section as? ProfileSection,
            let type = section.type else { return }
        switch type {
        case .bioInfo:
            return
        case .myRoomReservations:
            self.performSegue(withIdentifier: "toMyReservationsListTVC", sender: "conferenceRooms")
        case .myDeskReservations:
            self.performSegue(withIdentifier: "toMyReservationsListTVC", sender: "hotDesks")
        case .myServiceRequests:
            self.performSegue(withIdentifier: "ProfileVCtoMyServReqTVC", sender: nil)
        case .myRegisteredGuests:
            self.performSegue(withIdentifier: "ProfileVCtoMyGuestRegTVC", sender: nil)
        }
    }
}
