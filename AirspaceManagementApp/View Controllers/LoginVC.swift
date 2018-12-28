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
import CFAlertViewController
import NotificationBannerSwift

class LoginVC : UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var backgroundImageVIew: UIImageView!
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
//        self.loadVideo()
        usernameTextField.tintColor = globalColor
        passwordTextField.tintColor = globalColor
        forgotPasswordBtn.setTitleColor(.white, for: .normal)
        passwordTextField.isSecureTextEntry = true
        signInButton.setTitleColor(globalColor, for: .normal)
        signInButton.color = .white
        signInButton.cornerRadius = 0
        signInButton.highlightedColor = globalColor
        
        self.backgroundImageVIew.image = UIImage(named: "gradient")!
        self.backgroundImageVIew.frame = self.view.frame
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
        
        self.loadingIndicator = getGlobalLoadingIndicator(in: self.view)
        self.view.addSubview(self.loadingIndicator!)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.loadingIndicator?.stopAnimating()
    }

    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -125 // Move view 150 points upward
    }
    
    // add functionality here
    @IBAction func forgotPasswordBtnTapped(_ sender: Any) {
        self.showForgotPasswordOptions()
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
            let password = passwordTextField.text,
            self.isValidEmail(text: email) == true else {
                let alertController = CFAlertViewController(title: "Looks like you forgot something...", message: "Make sure to include a valid email and password.", textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
                let action = CFAlertAction(title: "Thanks", style: .Default, alignment: .center, backgroundColor: globalColor, textColor: nil, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true)
                return
        }
        
        self.loadingIndicator?.startAnimating()
        UserAuth.shared.signInUser(email: email, password: password) { (user, error) in
            if let _ = error {
                self.loadingIndicator?.stopAnimating()
                let banner = NotificationBanner(title: "Oh no!", subtitle: "There was an issue logging you in. Please check your credentials and try again.", leftView: nil, rightView: nil, style: .danger, colors: nil)
                banner.show()
                return
            }
            // else user will be taken to appropriate page automatically (listener active in App Delegate)
        }
    }
    
    func showForgotPasswordOptions() {
        let alert = UIAlertController(title: "Forgot Password?", message: "Just enter your email and we'll send you a link to reset your password.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Reset", style: .default) { (_) in
            if let tf = alert.textFields?[0] {
                let email = tf.text
                self.sendPasswordResetEmail(with: email)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func sendPasswordResetEmail(with email: String?) {
        guard let email = email, self.isValidEmail(text: email) == true else {
            let alertController = CFAlertViewController(title: "Looks like you forgot something...", message: "Make sure to include a valid email before requesting a reset link.", textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
            let action = CFAlertAction(title: "Thanks", style: .Default, alignment: .center, backgroundColor: globalColor, textColor: nil, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true)
            return
        }
        self.loadingIndicator?.startAnimating()
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            self.loadingIndicator?.stopAnimating()
            if let _ = error {
                let alertController = CFAlertViewController(title: "Oh no..", message: "We were unable to send you a link to reset your password.", textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
                let action = CFAlertAction(title: "Thanks", style: .Default, alignment: .center, backgroundColor: globalColor, textColor: nil, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true)
            } else {
                let alertController = CFAlertViewController(title: "Check your inbox!", message: "We've sent a link to reset your password to your email.", textAlignment: .center, preferredStyle: .alert, didDismissAlertHandler: nil)
                let action = CFAlertAction(title: "Thanks", style: .Default, alignment: .center, backgroundColor: globalColor, textColor: nil, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true)
            }
        }
    }
    
    func isValidEmail(text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
//    private func loadVideo() {
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers )
//        } catch { }
//
//        let path = Bundle.main.path(forResource: "background-video", ofType:"mp4")
//
//        self.player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
//        let playerLayer = AVPlayerLayer(player: player!)
//
//        playerLayer.frame = self.view.frame
//        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        playerLayer.zPosition = -1
//
//        self.view.layer.addSublayer(playerLayer)
//
//        player?.seek(to: CMTime.zero)
//        player?.play()
//    }
}
