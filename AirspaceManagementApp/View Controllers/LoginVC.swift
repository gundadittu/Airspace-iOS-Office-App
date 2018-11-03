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

class LoginVC : UIViewController {

    @IBOutlet weak var usernameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTextField: JVFloatLabeledTextField!
    @IBOutlet weak var signInButton: FlatButton!
    var player: AVPlayer?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadVideo()
        usernameTextField.tintColor = globalColor
        passwordTextField.tintColor = globalColor
        passwordTextField.isSecureTextEntry = true
        signInButton.color = globalColor
        signInButton.cornerRadius = 25
        signInButton.highlightedColor = globalColor
//        self.setStatusBarStyle(UIStatusBarStyleContrast)

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { _ in
            self.player?.seek(to: CMTime.zero)
            self.player?.play()
        }
    }
    
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        // Add logic to make sure fields are not blank, etc.
        guard let email = usernameTextField.text,
            let password = passwordTextField.text else {
                // Add error alert
                return
        }
        
        UserAuth.shared.signInUser(email: email, password: password) { (user, error) in
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
