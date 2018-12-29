//
//  InitialVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/29/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

class InitialVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image:  UIImage(named: "gradient")!)
        imageView.frame = self.view.frame
        self.view.addSubview(imageView)
    }
}
