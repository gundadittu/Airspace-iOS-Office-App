//
//  ServiceRequestManager.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/17/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import FirebaseFunctions
import FirebaseStorage

class ServiceRequestManager {
    static let shared = ServiceRequestManager()
    lazy var functions = Functions.functions()
    let storageRef = Storage.storage().reference()

    // pass image
    func createServiceRequest(officeUID: String, issueType: String, note: String?, image: UIImage?, completionHandler: @escaping (Error?) -> Void) {
        functions.httpsCallable("createServiceRequest").call(["officeUID":officeUID, "issueType": issueType, "note": note]) { (result, error) in
            if error != nil {
                completionHandler(error)
                return
            }
            if let image = image,
            let resultData = result?.data as? [String: Any],
            let id = resultData["id"] as? String {
                let data = image.jpegData(compressionQuality: 0.8)!
                // set upload path
                let filePath = "serviceRequestImages/\(id)"
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpg"
                self.storageRef.child(filePath).putData(data, metadata: metaData){(metaData,error) in
                    completionHandler(error)
                }
            } else {
                completionHandler(error)
            }
        }
    }
    
    func getAllServiceRequests(completionHandler: @escaping ([AirServiceRequest]?, [AirServiceRequest]?, [AirServiceRequest]?, Error?) -> Void) {
        functions.httpsCallable("getUsersServiceRequests").call { (result, error) in
            if let data = result?.data as? [String: Any],
            let open = data["open"] as? [[String: Any]],
            let pending = data["pending"] as? [[String: Any]],
            let closed = data["closed"] as? [[String: Any]] {
                let updatedOpen = open.compactMap({ x -> AirServiceRequest? in
                    return AirServiceRequest(dict: x)
                })
                let updatedClosed = closed.compactMap({ x -> AirServiceRequest? in
                    return AirServiceRequest(dict: x)
                })
                let updatedPending = pending.compactMap({ x -> AirServiceRequest? in
                    return AirServiceRequest(dict: x)
                })
                completionHandler(updatedOpen, updatedPending, updatedClosed, nil)
            } else {
                completionHandler(nil, nil, nil, error)
            }
        }
    }
    
    func cancelServiceRequest(serviceRequestID: String?,completionHandler: @escaping (Error?) -> Void) {
        functions.httpsCallable("cancelServiceRequest").call(["serviceRequestID": serviceRequestID]) { (_, error) in
            completionHandler(error)
        }
    }
}
