//
//  Yelp.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/26/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import Alamofire

class YelpDataController {
    
    class func getLocalRestaurauntCarouselObjects(completionHandler: @escaping ([CarouselCVCellItem]?) -> Void) {
        YelpDataController.getLocalRestaurauntsFromYelpAPI { (result) in
            var resultArr = [CarouselCVCellItem]()
            if let result = result {
                for item in result {
                    if let name = item["name"] as? String,
                        let imageURLString = item["image_url"] as? String {
                        let carouselItem = CarouselCVCellItem(title: name, subtitle: "", image: nil, imageURL: URL(string: imageURLString))
                        resultArr.append(carouselItem)
                    }
                }
                completionHandler(resultArr)
            }
            completionHandler(nil)
        }
    }
    
    class func getLocalRestaurauntsFromYelpAPI(completionHandler: @escaping ([[String:Any]]?) -> Void) {
        var returnArray = [[String: Any]]()
        let header: HTTPHeaders = [
            "Authorization": "Bearer ZTnEWfsLiFR1zEPtnrjcdFpNYOA-vdhbj4bGKgoSyAhxTv5PFSu-ifejqJpk4N08uprrrFvU1y8h0MmlErBAjNxP1-IRItqFAIeA8v_J0vJle0nCt71lm_xDk6_TW3Yx",
            "Accept": "application/json"
        ]
        let params = ["location": "Chicago"]
        Alamofire.request(URL(string: "https://api.yelp.com/v3/businesses/search")!, parameters: params, headers: header).responseJSON { response in
            if let json = response.result.value as? [String: Any],
                let businesses = json["businesses"] as? [[String: Any]] {
                for bus in businesses {
                    returnArray.append(bus)
                }
                completionHandler(returnArray)
            } else {
                completionHandler(nil)
            }
        }
    }
}
