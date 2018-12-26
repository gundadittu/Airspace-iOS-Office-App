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
    
    public init(delegate: MainVCDataControllerDelegate) {
        self.delegate = delegate
        self.loadTodayReservations()
    }
    
    public func loadTodayReservations() {
        ReservationManager.shared.getUsersReservationsForToday { (reservations, error) in
            if let error = error {
                self.delegate?.didUpdateReservationsToday(with: error)
            } else if let reservations = reservations {
                self.reservationsToday = reservations
                self.delegate?.didUpdateReservationsToday(with: nil)
            }
        }
    }
}
