//
//  EventProfileTVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/28/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit

enum EventProfileTVCSectionType {
    case bio
    case description
    case none
}

class EventProfileTVC: UITableViewController {
    var sections = [EventProfileTVCSectionType.bio, EventProfileTVCSectionType.description]
    var event: AirEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Event Description"
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.register(UINib(nibName: "EventsTVCell", bundle: nil), forCellReuseIdentifier: "EventsTVCell")

        if event == nil {
            fatalError("Did not provide value for self.event in EventProfileTVC")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        if indexPath.section == 0 {
            return CGFloat(200)
        }
        return CGFloat(1000)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTVCell", for: indexPath) as? EventsTVCell,
            let event = self.event else { return UITableViewCell() }
            cell.configure(with: event, delegate: self)
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventProfileTVCell", for: indexPath) as? EventProfileTVCell else { return UITableViewCell() }
            cell.textView.text = event?.descriptionText
            return cell
        }
        return UITableViewCell()
    }
}

extension EventProfileTVC: EventsTVCellDelegate {
    func didTapCell(with event: AirEvent) {
        return
    }
}

class EventProfileTVCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.isEditable = false
        self.textView.isSelectable = false
    }
}
