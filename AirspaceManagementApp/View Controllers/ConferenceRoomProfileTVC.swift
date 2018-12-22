//
//  ConferenceRoomProfileTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/20/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SwiftPullToRefresh

enum ConferenceRoomProfileSectionType {
    case bio
    case submit
    case none
}

class ConferenceRoomProfileSection : PageSection {
    var title = ""
    var type: ConferenceRoomProfileSectionType = .none
    
    public init(title: String, type: ConferenceRoomProfileSectionType) {
        self.title = title
        self.type = type
    }
}

class ConferenceRoomProfileTVC: UITableViewController {
    
    var sections = [ConferenceRoomProfileSection(title: "Bio", type: .bio), ConferenceRoomProfileSection(title: "Reserve Room", type: .submit)]
    var conferenceRoom: AirConferenceRoom?
    var startingDate = Date()
    var loadingIndicator: NVActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Conference Room Profile"        
          self.tableView.register(UINib(nibName: "ConferenceRoomDetailedTVC", bundle: nil), forCellReuseIdentifier: "ConferenceRoomDetailedTVC")
         self.tableView.register(UINib(nibName: "FormSubmitTVCell", bundle: nil), forCellReuseIdentifier: "FormSubmitTVCell")
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        
        self.loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: (self.tableView.frame.width/2)-25, y: (self.tableView.frame.height/2)-25, width: 50, height: 50), type: .ballClipRotate, color: globalColor, padding: nil)
        self.tableView.addSubview(self.loadingIndicator!)
        
        self.loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: (self.tableView.frame.width/2)-25, y: (self.tableView.frame.height/2)-25, width: 50, height: 50), type: .ballClipRotate, color: globalColor, padding: nil)
        self.tableView.addSubview(self.loadingIndicator!)
        
        self.tableView.spr_setTextHeader { [weak self] in
            self?.tableView.reloadData()
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDateInputVC",
            let destination = segue.destination as? DateTimeInputVC {
            destination.delegate = self
            destination.mode = .date
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section.type {
        case .bio:
            return 1
        case .none:
            return 0
        case .submit:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section.type {
        case .bio:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ConferenceRoomDetailedTVC", for: indexPath) as? ConferenceRoomDetailedTVC,
            let conferenceRoom = self.conferenceRoom else {
                return UITableViewCell()
            }
            cell.configureCell(with: conferenceRoom, for: startingDate)
            cell.setDelegate(with: self)
            return cell
        case .none:
            return UITableViewCell()
        case .submit:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSubmitTVCell") as? FormSubmitTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ConferenceRoomProfileTVC: FormTVCellDelegate {
    func didSelectCellButton(withObject object: PageSection) {
        // clicked submit button
        return
    }
}

extension ConferenceRoomProfileTVC: ConferenceRoomDetailedTVCDelegate {
    func didTapWhenDateButton() {
        // clicked when date button -> show date picker
        self.performSegue(withIdentifier: "toDateInputVC", sender: nil)
    }
    
    func startLoadingIndicator() {
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
        self.tableView.spr_endRefreshing()
    }
}

extension ConferenceRoomProfileTVC: DateTimeInputVCDelegate {
    func didSaveInput(with date: Date) {
        self.startingDate = date
        self.tableView.reloadData()
    }
}
