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
    var sections = [SpaceInfoTVCSection(title: "Building Details", buttonTitle: "View details", type: .buildingDetails), SpaceInfoTVCSection(title: "Floor plan", buttonTitle: "View floor plan", type: .floorplan), SpaceInfoTVCSection(title: "Office Onboarding", buttonTitle: "View onboarding", type: .officeOnboarding)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Space Info"
        self.tableView.separatorStyle = .none
        self.loadingIndicator = getGlobalLoadingIndicator(in: self.tableView)
        self.tableView.register(UINib(nibName: "FormTVCell", bundle: nil), forCellReuseIdentifier: "FormTVCell")
        self.tableView.spr_setTextFooter {
            return
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
            break
        case .floorplan:
            break
        case .buildingDetails:
            break
        case .none:
            break
        }
    }
}
