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
//        self.title = "PROFILE"
        self.navigationController?.navigationBar.topItem?.title = "Profile"

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "BioTVCell", bundle: nil), forCellReuseIdentifier: "BioTVCell")
        self.tableView.register(UINib(nibName: "CarouselTVCell", bundle: nil), forCellReuseIdentifier: "CarouselTVCell")
        self.tableView.register(UINib(nibName: "SeeMoreTVC", bundle: nil), forCellReuseIdentifier: "SeeMoreTVC")
        self.tableView.allowsSelection = false
        
        if self.dataController == nil {
            self.dataController = ProfileVCDataController(delegate: self)
        }
        
        self.loadingIndicator = getGlobalLoadingIndicator(in: self.tableView)
        self.view.addSubview(self.loadingIndicator!)
        
        self.tableView.spr_setTextHeader { [weak self] in
            self?.loadData()
        }
    }
    
    func loadData(){
        self.dataController?.loadData()
    }
}

extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func reloadTableView(){
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
    
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
                (type == .myRegisteredGuests || type == .myServiceRequests || type == .bioInfo) {
                return CGFloat(120)
            }
            return CGFloat(180)
        } else if indexPath.row == 1 {
            // see more buttons 
            return CGFloat(90)
        }
        return CGFloat(0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let currSection = sections[section]
//        guard let type = currSection.type else { return 0 }
//        switch type {
//        case .bioInfo:
//            break
//        case .myRoomReservations:
//            break
//        case .myDeskReservations:
//            break
//        case .myServiceRequests:
//            break
//        case .myRegisteredGuests:
//            break
//        }
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
                cell.delegate = self
                cell.setProfileImage(with: self.profileImage)
                cell.mainLbl.text = UserAuth.shared.displayName
                cell.subtitleLbl.text = UserAuth.shared.email
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeeMoreTVC", for: indexPath) as? SeeMoreTVC else {
                    return UITableViewCell()
                }
                cell.configureCell(with: currSection, buttonTitle: "Settings", delegate: self)
//                cell.button.setTitle("Settings", for: .normal)
                return cell
            }
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
                for reservation in self.roomReservations {
                    let item = CarouselCVCellItem(with: reservation)
                    carouselItems.append(item)
                }
                
                cell.identifier = "myRoomReservations"
                cell.delegate = self
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
                cell.identifier = "myRegisteredGuests"
                cell.delegate = self
                cell.setCarouselItems(with: carouselItems)
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
                cell.identifier = "myDeskReservations"
                cell.delegate = self
                
                var carouselItems = [CarouselCVCellItem]()
                for deskRes in self.deskReservations {
                    let item = CarouselCVCellItem(with: deskRes)
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
                cell.identifier = "myServiceRequests"
                cell.delegate = self
                cell.setCarouselItems(with: carouselItems)
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeeMoreTVC", for: indexPath) as? SeeMoreTVC else {
                    return UITableViewCell()
                }
                cell.configureCell(with: currSection, buttonTitle: currSection.seeMoreTitle ?? "More", delegate: self)
                return cell
            }
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
            // clicked on settings
            self.performSegue(withIdentifier: "toSettingsTVC", sender: nil)
        case .some(.myRoomReservations):
            self.performSegue(withIdentifier: "toMyReservationsListTVC", sender: "conferenceRooms")
        case .some(.myDeskReservations):
            self.performSegue(withIdentifier: "toMyReservationsListTVC", sender: "hotDesks")
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
            } else if identifier == "hotDesks" {
                destination.upcoming = self.dataController?.upcomingDeskReservations ?? []
                destination.past = self.dataController?.pastDeskReservations ?? []
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
            
            let action = CFAlertAction(title: "Ok", style: .Default, alignment: .left, backgroundColor: .red, textColor: .black, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true)
        } else {
            let alertController = CFAlertViewController(title: "Rock on!🤟🏼 ", message: "Your profile picture was updated.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
            
            let action = CFAlertAction(title: "Sounds Good", style: .Default, alignment: .right, backgroundColor: globalColor, textColor: nil, handler: nil)
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
        }
        if let open = self.dataController?.openSR,
            let pending = self.dataController?.closedSR {
            var array = [AirServiceRequest]()
            array.append(contentsOf: open)
            array.append(contentsOf: pending)
            self.serviceRequests = array
        }
        if let upcomingRes = self.dataController?.upcomingReservations {
            self.roomReservations = upcomingRes
        }
        if let upcomingDeskRes = self.dataController?.upcomingDeskReservations {
            self.deskReservations = upcomingDeskRes
        }
        
        if let profileImage = self.dataController?.profileImage {
            self.profileImage = profileImage
        }
        
        
        if (self.dataController?.isLoading == false) {
            self.tableView.spr_endRefreshing()
        }
        self.reloadTableView()
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
}

extension ProfileVC {
    
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
