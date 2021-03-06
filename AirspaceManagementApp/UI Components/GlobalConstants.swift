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

let globalColor = UIColor(hexString: "FC588F")!

// https://github.com/ninjaprox/NVActivityIndicatorView
func getGlobalLoadingIndicator(in view: UIView, with color: UIColor = globalColor, and size: CGFloat = 60) ->  NVActivityIndicatorView {
    let frame = CGRect(x:view.layer.frame.midX-(size/2), y: view.layer.frame.midY-(size/2), width: size, height: size)
    return NVActivityIndicatorView(frame: frame, type: .circleStrokeSpin, color: color, padding: nil)
}

func getGlobalLoadingIndicator(in frame: CGRect, with color: UIColor = globalColor, and size: CGFloat = 60, yOffset: CGFloat = 30) ->  NVActivityIndicatorView {
    return NVActivityIndicatorView(frame: frame, type: .circleStrokeSpin, color: color, padding: nil)
}


let globalTextAttrs: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)]

let globalBoldTextAttrs: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15)]

let globalWhiteTextAttrs: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)]

