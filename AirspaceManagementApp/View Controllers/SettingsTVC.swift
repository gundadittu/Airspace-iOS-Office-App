//
//  SettingsTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/24/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import SafariServices
import NotificationBannerSwift
import MessageUI
import NVActivityIndicatorView
import FirebaseAuth
import CFAlertViewController

class SettingsTVC: UITableViewController, MFMailComposeViewControllerDelegate {
    var sections = [SettingsTVCSection]()
    var loadingIndicator: NVActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.sections = [SettingsTVCSection(title: "Notification Settings", type: .notifications), SettingsTVCSection(title: "Change Password", type: .changePassword), SettingsTVCSection(title: "Get in touch with us", type: .contact),
        SettingsTVCSection(title: "Terms of Use", type: .terms),
        SettingsTVCSection(title: "Privacy Policy", type: .privacyPolicy),
        SettingsTVCSection(title: "Acknowledgements", type: .acknowledgments),
        SettingsTVCSection(title: "Log Out", type: .logOut),
        SettingsTVCSection(title: "Version: "+(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "N/A"), type: .version)]
        self.tableView.separatorStyle = .none
        
        self.loadingIndicator = getGlobalLoadingIndicator(in: self.view)
        self.view.addSubview(self.loadingIndicator!)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let section = sections[indexPath.section]
        if let type = section.type,
            type == .version {
            return false
        }
        return true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        guard let type = section.type else { return }
        switch type {
        case .contact:
            self.sendEmail()
        case .terms:
            if let url = URL(string: "https://www.airspaceoffice.co/terms") {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true, completion: nil)
            }
        case .privacyPolicy:
            if let url = URL(string: "https://www.airspaceoffice.co/privacy") {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true, completion: nil)
            }
        case .acknowledgments:
            if let url = URL(string: "https://www.airspaceoffice.co/ios-app-acknowledgements") {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true, completion: nil)
            }
        case .logOut:
            self.showLogOutAlert()
        case .version:
            break
        case .notifications:
            NotificationManager.shared.requestPermission(true)
        case .changePassword:
            self.changePassword()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.configureCell(with: section)
        return cell
    }
    
    func changePassword() {
        guard let email = UserAuth.shared.email else {
            // handle error
            return
        }
        self.loadingIndicator?.startAnimating()
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            self.loadingIndicator?.stopAnimating()
            if let _ = error {
                let alertController = CFAlertViewController(title: "Oh no..", message: "We were unable to send you a link to change your password.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
                let action = CFAlertAction(title: "Thanks", style: .Default, alignment: .justified, backgroundColor: globalColor, textColor: nil, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true)
            } else {
                let alertController = CFAlertViewController(title: "Check your inbox!", message: "We've sent a link to change your password to your email.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
                let action = CFAlertAction(title: "Thanks", style: .Default, alignment: .justified, backgroundColor: globalColor, textColor: nil, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true)
            }
        }
    }

    
    func showLogOutAlert() {
        let alert = UIAlertController(title: "Logging Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Log Out", style: .default) { (_) in
            UserAuth.shared.signOutUser() { error in
                if let _ = error {
                    let banner = StatusBarNotificationBanner(title: "Error signing out.", style: .danger)
                    banner.show()
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["hello@airspaceoffice.co"])
            present(mail, animated: true)
        } else {
            let banner = NotificationBanner(title: "Woops!", subtitle: "We're unable to access your mail app. To get in touch with us, shoot us an email at hello@airspaceoffice.co.", leftView: nil, rightView: nil, style: .danger, colors: nil)
            banner.show()
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
