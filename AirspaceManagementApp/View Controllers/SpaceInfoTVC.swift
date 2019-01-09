//
//  SpaceInfoTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/26/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import SwiftPullToRefresh
import NVActivityIndicatorView
import SafariServices
import NotificationBannerSwift

enum SpaceInfoTVCSectionType: String {
    case officeOnboarding
    case floorplan
    case buildingDetails
    case none
}

class SpaceInfoTVCSection: PageSection {
    var title = ""
    var buttonTitle = ""
    var type: SpaceInfoTVCSectionType = .none
    
    public init(title: String, buttonTitle: String, type: SpaceInfoTVCSectionType) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.type = type
    }
}

class SpaceInfoTVC: UITableViewController {
    
    var loadingIndicator: NVActivityIndicatorView?
    var dataController: SpaceInfoTVCDataController?
    var buildingDetails: URL?
    var floorPlan: URL?
    var onboardingURL: URL?
    var sections = [SpaceInfoTVCSection(title: "Building Details", buttonTitle: "View details", type: .buildingDetails), SpaceInfoTVCSection(title: "Floor plan", buttonTitle: "View floor plan", type: .floorplan), SpaceInfoTVCSection(title: "Office Onboarding", buttonTitle: "View onboarding", type: .officeOnboarding)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Space Info"
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        
        let loadingIndicator = getGlobalLoadingIndicator(in: self.view)
        self.loadingIndicator = loadingIndicator
        self.view.addSubview(loadingIndicator)
        
        self.tableView.register(UINib(nibName: "FormTVCell", bundle: nil), forCellReuseIdentifier: "FormTVCell")
        self.tableView.spr_setTextFooter {
            self.dataController?.loadData()
        }
        
        if self.dataController == nil {
            self.dataController = SpaceInfoTVCDataController(delegate: self)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell", for: indexPath) as? FormTVCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: self.sections[indexPath.section], delegate: self)
        return cell
    }
}

extension SpaceInfoTVC: FormTVCellDelegate {
    func didSelectCellButton(withObject object: PageSection) {
        guard let object = object as? SpaceInfoTVCSection else { return }
        switch object.type {
        case .officeOnboarding:
            if let url = self.onboardingURL {
                let vc = SFSafariViewController(url: url)
                vc.preferredControlTintColor = globalColor
                present(vc, animated: true, completion: nil)
            } else {
                self.showError()
            }
        case .floorplan:
            if let url = self.floorPlan {
                let vc = SFSafariViewController(url: url)
                vc.preferredControlTintColor = globalColor
                present(vc, animated: true, completion: nil)
            } else {
                self.showError()
            }
        case .buildingDetails:
            if let url = self.buildingDetails {
                let vc = SFSafariViewController(url: url)
                vc.preferredControlTintColor = globalColor
                present(vc, animated: true, completion: nil)
            } else {
                self.showError()
            }
        case .none:
            self.showError()
        }
    }
    
    func showError() {
        let banner = StatusBarNotificationBanner(title: "There was an issue opening the relevant content.", style: .danger)
        banner.show()
    }
}

extension SpaceInfoTVC: SpaceInfoTVCDataControllerDelegate {
    func didLoadData() {
        if let buildingDetails = self.dataController?.buildingDetails {
            self.buildingDetails = buildingDetails
        }
        if let floorPlan = self.dataController?.floorPlan {
            self.floorPlan = floorPlan
        }
        if let onboardingURL = self.dataController?.onboardingURL {
            self.onboardingURL = onboardingURL
        }
        self.tableView.reloadData()
    }
    
    func startLoadingIndicator() {
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
    }
}
