//
//  DeskReservationVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/29/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

protocol DeskReservationVCDataControllerDelegate {
    func didFinishSubmittingData(withError error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
    func reloadTableView()
}

class DeskReservationVCDataController {
    var hotDesk: AirDesk?
    var selectedStartDate: Date?
    var selectedEndDate: Date?
    var delegate: DeskReservationVCDataControllerDelegate?
    var originalReservation: AirDeskReservation?
    
    public init(delegate: DeskReservationVCDataControllerDelegate) {
        self.delegate = delegate
    }
    
    public func setHotDeskReservation(with reservation: AirDeskReservation) {
        self.hotDesk = reservation.desk
        self.selectedStartDate = reservation.startingDate
        self.selectedEndDate = reservation.endDate
        self.originalReservation = reservation
        self.delegate?.reloadTableView()
    }
    public func setDesk(with desk: AirDesk) {
        self.hotDesk = desk
        self.delegate?.reloadTableView()
    }
    
    public func setSelectedStartDate(with date: Date?) {
        self.selectedStartDate = date
    }
    
    public func setSelectedEndDate(with date: Date?) {
        self.selectedEndDate = date
    }

    public func resetToOriginal() {
        guard let deskRes = self.originalReservation else { return }
        self.setHotDeskReservation(with: deskRes)
    }
    
    public func updateToOriginalTimes() {
        self.selectedStartDate = self.originalReservation?.startingDate
        self.selectedEndDate = self.originalReservation?.endDate
    }
    
    public func submitData() {
        guard let reservationUID = self.originalReservation?.uid,
            let originalStart = self.originalReservation?.startingDate,
            let originalEnd = self.originalReservation?.endDate else {
                self.delegate?.didFinishSubmittingData(withError: NSError())
                return
        }
        
        let startTime = self.selectedStartDate ?? originalStart
        let endTime = self.selectedEndDate ?? originalEnd
        
        self.delegate?.startLoadingIndicator()
        DeskReservationManager.shared.updateHotDeskReservation(reservationUID: reservationUID, startTime: startTime, endTime: endTime) { (error) in
            self.delegate?.stopLoadingIndicator()
            self.delegate?.didFinishSubmittingData(withError: error)
        }
    }
}
