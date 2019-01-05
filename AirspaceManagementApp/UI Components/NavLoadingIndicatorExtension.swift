//
//  NavLoadingIndicatorExtension.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/25/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit

//extension  UIViewController {
//    func showActivityIndicator() {
//        let activityIndicatorView = UIActivityIndicatorView(style: .white)
//        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
//        activityIndicatorView.color = .black
//        activityIndicatorView.startAnimating()
//        
//        let titleLabel = UILabel()
//        titleLabel.text = "Loading.."
//        titleLabel.font = UIFont.italicSystemFont(ofSize: 14)
//        
//        let fittingSize = titleLabel.sizeThatFits(CGSize(width: 200.0, height: activityIndicatorView.frame.size.height))
//        titleLabel.frame = CGRect(x: activityIndicatorView.frame.origin.x + activityIndicatorView.frame.size.width + 8,
//                                  y: activityIndicatorView.frame.origin.y,
//                                  width: fittingSize.width,
//                                  height: fittingSize.height)
//        
//        let rect = CGRect(x: (activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width) / 2,
//                          y: (activityIndicatorView.frame.size.height) / 2,
//                          width: activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width,
//                          height: activityIndicatorView.frame.size.height)
//        let titleView = UIView(frame: rect)
//        titleView.addSubview(activityIndicatorView)
//        titleView.addSubview(titleLabel)
//        
//       self.navigationItem.titleView = titleView
//    }
//    
//    func hideActivityIndicator() {
//        self.navigationItem.titleView = nil
//    }
//}
