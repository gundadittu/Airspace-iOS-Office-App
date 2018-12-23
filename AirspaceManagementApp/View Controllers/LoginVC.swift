//
//  LoginVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/15/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import AVFoundation
import JVFloatLabeledTextField
import SwiftyButton
import NVActivityIndicatorView

class LoginVC : UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTextField: JVFloatLabeledTextField!
    @IBOutlet weak var signInButton: FlatButton!
    var player: AVPlayer?
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    var loadingIndicator: NVActivityIndicatorView?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadVideo()
        usernameTextField.tintColor = globalColor
        passwordTextField.tintColor = globalColor
        forgotPasswordBtn.setTitleColor(.white, for: .normal)
        passwordTextField.isSecureTextEntry = true
        signInButton.color = globalColor
        signInButton.cornerRadius = 25
        signInButton.highlightedColor = globalColor

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { _ in
            self.player?.seek(to: CMTime.zero)
            self.player?.play()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil);
        
        self.usernameTextField.tag = 1
        self.passwordTextField.tag = 2
        self.usernameTextField.delegate = self 
        self.passwordTextField.delegate = self
        
        self.loadingIndicator = getGLobalLoadingIndicator(in: self.view)
        self.view.addSubview(self.loadingIndicator!)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -125 // Move view 150 points upward
    }
    
    // add functionality here
    @IBAction func forgotPasswordBtnTapped(_ sender: Any) {
        return
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            let nextResponder: UIResponder = textField.superview!.viewWithTag(2)!
            nextResponder.becomeFirstResponder()
            return false
        } else if textField.tag == 2 {
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        // Add logic to make sure fields are not blank, etc.
        guard let email = usernameTextField.text,
            let password = passwordTextField.text else {
                // Add error alert
                return
        }
        
        self.loadingIndicator?.startAnimating()
        UserAuth.shared.signInUser(email: email, password: password) { (user, error) in
            self.loadingIndicator?.stopAnimating()
            if user == nil || error != nil {
                // add error alert otherwise
            }
            // user will be taken to appropriate page automatically (listener active in App Delegate)
        }
    }
    
    private func loadVideo() {
        
        //this line is important to prevent background music stop
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers )
        } catch { }
        
        let path = Bundle.main.path(forResource: "background-video", ofType:"mp4")
        
        self.player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player!)
        
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        
        self.view.layer.addSublayer(playerLayer)
        
        player?.seek(to: CMTime.zero)
        player?.play()
    }
}
