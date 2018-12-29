//
//  ProfileVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/22/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

class ProfileVCDataController {
    var upcomingGuests = [AirGuestRegistration]()
    var pastGuests = [AirGuestRegistration]()
    
    var openSR = [AirServiceRequest]()
    var pendingSR = [AirServiceRequest]()
    var closedSR = [AirServiceRequest]()
    
    var upcomingReservations = [AirConferenceRoomReservation]()
    var pastReservations = [AirConferenceRoomReservation]()
    
    var upcomingDeskReservations = [AirDeskReservation]()
    var pastDeskReservations = [AirDeskReservation]()

    var profileImage: UIImage?
    var delegate: ProfileVCDataControllerDelegate?
    
    var isLoading: Bool {
        if profileImageLoading {
            return true
        }
        if serviceRequestLoading {
            return true
        }
        if registeredGuestLoading {
            return true
        }
        if roomReservationsLoading {
            return true
        }
        return false
    }
    
    var profileImageLoading = false
    var serviceRequestLoading = false
    var registeredGuestLoading = false
    var roomReservationsLoading = false
    var deskReservationsLoading = false
    
    public init(delegate: ProfileVCDataControllerDelegate) {
        self.delegate = delegate
        self.loadData()
    }
    
    func loadData() {
        self.loadUpcomingGuestRegistrations()
        self.loadServiceRequests()
        self.loadConferenceRoomReservations()
        self.loadProfileImage()
        self.loadHotDeskReservations()
    }
    
    func loadServiceRequests() {
        self.serviceRequestLoading = true
        self.delegate?.startLoadingIndicator()
        ServiceRequestManager.shared.getAllServiceRequests { (open, pending, closed, error) in
            self.serviceRequestLoading = false
            self.delegate?.stopLoadingIndicator()
         
            if let open = open {
                self.openSR = open
            }
            if let pending = pending {
                self.pendingSR = pending
            }
            if let closed = closed {
                self.closedSR = closed
            }
            self.delegate?.didUpdateCarouselData()
        }
    }
    
    func loadUpcomingGuestRegistrations() {
        self.registeredGuestLoading = true
        self.delegate?.startLoadingIndicator()
        RegisterGuestManager.shared.getUsersRegisteredGuests { (upcoming, past, error) in
            self.delegate?.stopLoadingIndicator()
            self.registeredGuestLoading = false
            
            if let upcoming = upcoming {
                self.upcomingGuests = upcoming
            }
            if let past = past {
                self.pastGuests = past
            }
            self.delegate?.didUpdateCarouselData()
        }
    }
    
    func loadProfileImage() {
        guard let uid = UserAuth.shared.uid else { return }
        self.profileImageLoading = true
        UserManager.shared.getProfileImage(for: uid) { (image, _) in
            self.profileImageLoading = false 
            if let image = image {
                self.profileImage = image
            }
            self.delegate?.didUpdateCarouselData()
        }
    }
    
    func uploadNewProfileImage(with image: UIImage?) {
        guard let uid = UserAuth.shared.uid,
            let image = image,
            let data = image.jpegData(compressionQuality: CGFloat(0.7)) else {
                self.delegate?.didFinishUploadingNewImage(with: NSError())
                return
        }
        let storageRef = Storage.storage().reference()
        let profileRef = storageRef.child("userProfileImages/\(uid).jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        let _ = profileRef.putData(data, metadata: nil) { (_, error) in
            if let error = error {
                self.delegate?.didFinishUploadingNewImage(with: error)
            } else {
               self.loadProfileImage()
                self.delegate?.didFinishUploadingNewImage(with: nil)
            }
        }

    }
    
    func loadConferenceRoomReservations() {
        self.roomReservationsLoading = true
        self.delegate?.startLoadingIndicator()
        ReservationManager.shared.getAllConferenceRoomReservationsForUser { (upcoming, past, error) in
            self.roomReservationsLoading = false
            self.delegate?.stopLoadingIndicator()
            if let upcoming = upcoming {
                self.upcomingReservations = upcoming
            }
            if let past = past {
                self.pastReservations = past
            }
            self.delegate?.didUpdateCarouselData()
        }
    }
    
    func loadHotDeskReservations() {
        self.deskReservationsLoading = true
        self.delegate?.startLoadingIndicator()
        DeskReservationManager.shared.getAllHotDeskReservationsForUser { (upcoming, past, error) in
            self.deskReservationsLoading = false
            self.delegate?.stopLoadingIndicator()
            if let upcoming = upcoming {
                self.upcomingDeskReservations = upcoming
            }
            if let past = past {
                self.pastDeskReservations = past
            }
            self.delegate?.didUpdateCarouselData()
        }
    }
}
