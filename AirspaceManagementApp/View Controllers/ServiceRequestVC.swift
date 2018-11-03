//
//  ServiceRequestVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/15/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit

class ServiceRequestVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var fields = [SubmitTicketField(title: "There's an issue in", actionTitle: "Building X")]
    let reuseID = "serv-req-cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Submit a Ticket"
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self 
    }
}

extension ServiceRequestVC: UITableViewDelegate {
    
}

extension ServiceRequestVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? SubmitTicketTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = fields[indexPath.section].title
        cell.mainButton.titleLabel?.text = fields[indexPath.section].actionTitle
        return cell
    }
}
