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

enum SettingsTVCSectionType {
    case reportBugs
    case suggestFeatures
    case terms
    case privacyPolicy
    case acknowledgments
    case logOut
}

class SettingsTVCSection: PageSection {
    var title: String?
    var type: SettingsTVCSectionType?
    
    public init(title: String, type: SettingsTVCSectionType) {
        self.title = title
        self.type = type
    }
}

class SettingsTVC: UITableViewController {
    var sections = [SettingsTVCSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.sections = [SettingsTVCSection(title: "Report Bugs", type: .reportBugs),
        SettingsTVCSection(title: "Suggest Features", type: .suggestFeatures),
        SettingsTVCSection(title: "Terms of Use", type: .terms),
        SettingsTVCSection(title: "Privacy Policy", type: .privacyPolicy),
        SettingsTVCSection(title: "Acknowledgements", type: .acknowledgments),
        SettingsTVCSection(title: "Log Out", type: .logOut)]
//        self.tableView.register(UINib(nibName: "FormSubmitTVCell", bundle: nil), forCellReuseIdentifier: "FormSubmitTVCell")
        self.tableView.separatorStyle = .none
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
        case .reportBugs:
            break
        case .suggestFeatures:
            break
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
            break
        case .logOut:
            self.showLogOutAlert()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.configureCell(with: section)
        guard let type = section.type else { return UITableViewCell() }
        switch type {
        case .reportBugs:
            break
        case .suggestFeatures:
            break
        case .terms:
            break
        case .privacyPolicy:
            break
        case .acknowledgments:
            break
        case .logOut:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSubmitTVCell", for: indexPath) as? FormSubmitTVCell else { return UITableViewCell() }
//            cell.button.setTitle("Log Out", for: .normal)
//            return cell
            cell.textLabel?.textColor = .red
            break
        }
        return cell
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
}

//extension SettingsTVC: SeeMoreTVCDelegate {
//    func didSelectSeeMore(for section: PageSection) {
//        // did click log out
//        UserAuth.shared.signOutUser() { error in
//            if let _ = error {
//                let banner = StatusBarNotificationBanner(title: "Error signing out.", style: .danger)
//                banner.show()
//            }
//        }
//    }
//}
