//
//  DataControllerDelegates.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/27/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

protocol RegisterGuestTVCDataControllerDelegate {
    func didFinishSubmittingData(withError: Error?)
    func toggleLoadingIndicator()
    func reloadTableView()
}

protocol ProfileVCDataControllerDelegate {
    func didUpdateCarouselData()
    func didFinishUploadingNewImage(with error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
}

protocol ServiceRequestVCDataControllerDelegate {
    func didFinishSubmittingData(withError error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
    func reloadTableView()
}

protocol FindRoomVCDataControllerDelegate {
    func didFindAvailableConferenceRooms(rooms: [AirConferenceRoom]?, error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
    func reloadTableView()
}

protocol ConferenceRoomProfileDataControllerDelegate {
    func didFinishSubmittingData(withError error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
    func reloadTableView()
}

protocol NotificationVCDataControllerDelegate {
    func didLoadNotifications(_ notifications: [AirNotification]?, with error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
}

protocol RoomReservationVCDataControllerDelegate {
    func didFinishSubmittingData(withError error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
    func reloadTableView()
}

protocol MainVCDataControllerDelegate {
    func didUpdateReservationsToday(with error: Error?)
    func startLoadingIndicator()
    func stopLoadingIndicator()
    func didUpdateSections(with sections: [MainVCSection])
}

protocol SpaceInfoTVCDataControllerDelegate {
    
}
