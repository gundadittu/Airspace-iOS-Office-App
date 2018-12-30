//
//  TextInputVCViewController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/17/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

class TextInputVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var delegate: TextInputVCDelegate?
    var initialText: String?
    var identifier: String? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = self.delegate else {
            fatalError("Need to provide delegate value for TextInputVC")
        }
        self.textView.tintColor = globalColor
        self.textView.becomeFirstResponder()
        
        if let initialText = self.initialText  {
            self.textView.text = initialText
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didClickSave))
    }
    
    @objc func didClickSave() {
        if let text = self.textView.text {
            self.delegate?.didSaveInput(with: text, and: identifier)
        }
        self.navigationController?.popViewController(animated: true)
    }

}
