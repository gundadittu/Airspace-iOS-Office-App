//
//  ReserveVCDataController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 1/1/19.
//  Copyright © 2019 Aditya Gunda. All rights reserved.
//

import Foundation

protocol ReserveVCDataControllerDelegate {
    func startLoadingIndicator()
    func stopLoadingIndicator()
    func didLoadData(allRooms: [AirConferenceRoom]?, allDesks: [AirDesk]?, with error: Error?)
}

class ReserveVCDataController {
    var delegate: ReserveVCDataControllerDelegate?
    var allConferenceRooms = [AirConferenceRoom]()
    var allHotDesks = [AirDesk]()
    var loadingRooms = false
    var loadingDesks = false
    var isLoading: Bool {
        return self.loadingRooms || self.loadingDesks
    }

    public init(delegate: ReserveVCDataControllerDelegate) {
        self.delegate = delegate
        loadData()
    }
    
    
    func loadData(for type: ReserveVCConfiguration? = nil) {
        if type == nil {
            loadAllConferenceRooms()
            loadAllHotDesks()
        } else if let type = type {
            switch type {
            case .conferenceRooms:
                loadAllConferenceRooms()
            case .hotDesks:
                loadAllHotDesks()
            }
        }
       
    }
    
    func loadAllHotDesks() {
        self.loadingDesks = true
        self.delegate?.startLoadingIndicator()
        FindDeskManager.shared.getAllHotDesksForUser { (desks, error) in
            self.loadingDesks = false
            self.delegate?.stopLoadingIndicator()
            if let error = error {
                self.delegate?.didLoadData(allRooms: nil, allDesks: nil, with: error)
            } else if let desks = desks {
                self.allHotDesks = desks
                self.delegate?.didLoadData(allRooms: nil, allDesks: desks, with: nil)
            } else {
                self.delegate?.didLoadData(allRooms: nil, allDesks: nil, with: NSError())
            }
        }
    }

    func loadAllConferenceRooms() {
        self.loadingRooms = true
        self.delegate?.startLoadingIndicator()
        FindRoomManager.shared.getAllConferenceRoomsForUser { (rooms, error) in
            self.loadingRooms = false 
            self.delegate?.stopLoadingIndicator()
            if let error = error {
                 self.delegate?.didLoadData(allRooms: nil, allDesks: nil, with: error)
            } else if let rooms = rooms {
                self.allConferenceRooms = rooms
                self.delegate?.didLoadData(allRooms: rooms, allDesks: nil, with: nil)
            } else {
                 self.delegate?.didLoadData(allRooms: nil, allDesks: nil, with: NSError())
            }
        }
    }
}
