//
//  MainVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/26/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

protocol MainVCDataControllerDelegate {
    func didUpdateReservationsToday(with error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
}

class MainVCDataController {
    var reservationsToday = [AirReservation]()
    var delegate: MainVCDataControllerDelegate?
    
    var isLoading: Bool {
        if loadingTodayReservations {
            return true
        }
        return false
    }
    var loadingTodayReservations = false
    
    public init(delegate: MainVCDataControllerDelegate) {
        self.delegate = delegate
        self.loadData()
    }
    
    public func loadData() {
        self.loadTodayReservations()
    }
    
    public func loadTodayReservations() {
        self.loadingTodayReservations = true
        self.delegate?.startLoadingIndicator()
        ReservationManager.shared.getUsersReservationsForToday { (reservations, error) in
            self.loadingTodayReservations = false 
            self.delegate?.stopLoadingIndicator()
            if let error = error {
                self.delegate?.didUpdateReservationsToday(with: error)
            } else if let reservations = reservations {
                self.reservationsToday = reservations
                self.delegate?.didUpdateReservationsToday(with: nil)
            }
        }
    }
}
