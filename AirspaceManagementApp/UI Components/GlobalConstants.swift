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

let globalColor = UIColor(hexString: "f07c94")!

// https://github.com/ninjaprox/NVActivityIndicatorView
func getGlobalLoadingIndicator(in view: UIView, with color: UIColor = globalColor, and size: CGFloat = 60, yOffset: CGFloat = 30) ->  NVActivityIndicatorView {
    return NVActivityIndicatorView(frame: CGRect(x: (view.frame.width/2)-(size/2), y: (view.frame.height/2)-yOffset, width: size, height: size), type: .circleStrokeSpin, color: color, padding: nil)
}
