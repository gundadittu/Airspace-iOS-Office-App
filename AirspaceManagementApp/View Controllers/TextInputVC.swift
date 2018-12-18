//
//  TextInputVCViewController.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/17/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

protocol TextInputVCDelegate {
    func didSaveInput(with text: String)
}

class TextInputVC: UIViewController {

    @IBOutlet var textView: UITextView!
    var delegate: TextInputVCDelegate?
    var initialText: String?
    
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
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didClickSave))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc func didClickSave() {
        if let text = self.textView.text {
            self.delegate?.didSaveInput(with: text)
        }
        self.navigationController?.popViewController(animated: true)
    }

}
