//
//  AirDeskReservation.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/25/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation

class AirDeskReservation: AirReservation {
    var desk: AirDesk?
    var deskUID: String?
    
    override public init?(dict: [String: Any]) {
        super.init(dict: dict)
       
        
        if let deskUID = dict["deskUID"] as? String {
            self.deskUID = deskUID
        } else {
            print("No deskUID found for hot desk reservation")
            return nil
        }
        
        if let deskDict = dict["hotDesk"] as? [String: Any],
            let desk = AirDesk(dict: deskDict) {
            self.desk = desk
        } else {
            print("No desk found for desk reservation")
        }
    }
}
