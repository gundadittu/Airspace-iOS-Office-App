//
//  ProfileVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/22/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

protocol ProfileVCDataControllerDelegate {
    func didUpdateCarouselData()
    func startLoadingIndicator()
    func stopLoadingIndicator()
}

class ProfileVCDataController {
    var upcomingGuests = [AirGuestRegistration]()
    var pastGuests = [AirGuestRegistration]()
    
    var openSR = [AirServiceRequest]()
    var pendingSR = [AirServiceRequest]()
    var closedSR = [AirServiceRequest]()
    
    var upcomingReservations = [AirConferenceRoomReservation]()
    var pastReservations = [AirConferenceRoomReservation]()

    var delegate: ProfileVCDataControllerDelegate?
    
    public init(delegate: ProfileVCDataControllerDelegate) {
        self.delegate = delegate
        self.loadData()
    }
    
    func loadData() {
        self.loadUpcomingGuestRegistrations()
        self.loadServiceRequests()
        self.loadConferenceRoomReservations()
    }
    
    func loadServiceRequests() {
        self.delegate?.startLoadingIndicator()
        ServiceRequestManager.shared.getAllServiceRequests { (open, pending, closed, error) in
            self.delegate?.stopLoadingIndicator()
            //Handle error 
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
        self.delegate?.startLoadingIndicator()
        RegisterGuestManager.shared.getUsersRegisteredGuests { (upcoming, past, error) in
            self.delegate?.stopLoadingIndicator()
            
            // HANDLE ERROR
            if let error = error {
                return
            }
            
            if let upcoming = upcoming {
                self.upcomingGuests = upcoming
            }
            if let past = past {
                self.pastGuests = past
            }
            self.delegate?.didUpdateCarouselData()
        }
    }
    
    func loadConferenceRoomReservations() {
        self.delegate?.startLoadingIndicator()
        ReservationManager.shared.getAllConferenceRoomReservationsForUser { (upcoming, past, error) in
            self.delegate?.stopLoadingIndicator()
            if let error = error {
                // handle error
                return
            }
            if let upcoming = upcoming {
                self.upcomingReservations = upcoming
            }
            if let past = past {
                self.pastReservations = past
            }
            self.delegate?.didUpdateCarouselData()
        }
    }
}
