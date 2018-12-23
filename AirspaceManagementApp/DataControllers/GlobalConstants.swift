//
//  GlobalConstants.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/26/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework
import NVActivityIndicatorView

let globalColor = UIColor(hexString: "F07C94")!

// https://github.com/ninjaprox/NVActivityIndicatorView
func getGLobalLoadingIndicator(in view: UIView) ->  NVActivityIndicatorView {
    return NVActivityIndicatorView(frame: CGRect(x: (view.frame.width/2)-25, y: (view.frame.height/2)-150, width: 60, height: 60), type: .squareSpin, color: globalColor, padding: nil)
}
