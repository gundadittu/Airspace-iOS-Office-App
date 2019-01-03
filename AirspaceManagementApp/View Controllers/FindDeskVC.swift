//
//  FindDeskVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/28/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import NotificationBannerSwift

class FindDeskVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var sections = [ FindDeskVCSection(title: "I need a desk in", buttonTitle: "Choose Office", type: .office), FindDeskVCSection(title: "starting at", buttonTitle: "Select Time", type: .startTime), FindDeskVCSection(title: "for around", buttonTitle: "Choose Duration", type: .duration), FindDeskVCSection(title: "Find Available Desks", buttonTitle: "Find Available Desks", type: .submit)]
    var loadingIndicator: NVActivityIndicatorView?
    var dataController: FindDeskVCDataController?
    var shouldAutomaticallySubmit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Find a Hot Desk"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FormTVCell", bundle: nil), forCellReuseIdentifier: "FormTVCell")
        self.tableView.register(UINib(nibName: "FormSubmitTVCell", bundle: nil), forCellReuseIdentifier: "FormSubmitTVCell")
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        
        let loadingIndicator = getGlobalLoadingIndicator(in: self.view)
        self.loadingIndicator = loadingIndicator
        self.view.addSubview(loadingIndicator)
        
        if dataController == nil {
            self.dataController = FindDeskVCDataController(delegate: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChooseTVC",
            let destination = segue.destination as? ChooseTVC,
            let sender = sender as? ChooseTVCType {
            destination.type = sender
            destination.delegate = self
        } else if segue.identifier == "toDateTimeInputVC",
            let destination = segue.destination as? DateTimeInputVC {
            destination.delegate = self
            if let initialDate = self.dataController?.selectedStartDate {
                destination.initialDate = initialDate
            }
        } else if segue.identifier == "toDeskListVC",
            let destination = segue.destination as? DeskListVC,
            let sender = sender as? [AirDesk] {
            destination.hotDesks = sender
            destination.startingDate = self.dataController?.selectedStartDate ?? Date()
            if let currDataController = self.dataController {
                let newDataController = FindDeskVCDataController(delegate: destination)
                newDataController.configure(with: currDataController)
                newDataController.delegate = destination
                destination.dataController = newDataController
            }
        }
    }
}

extension FindDeskVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.row]
        switch section.type {
        case .office:
            if let office = self.dataController?.selectedOffice {
                section.selectedButtonTitle = office.name
            } else {
                section.selectedButtonTitle = nil
            }
        case .startTime:
            if let date = self.dataController?.selectedStartDate {
                let dateString = date.localizedMedDateDescription+" at "+date.localizedDescriptionNoDate
                section.selectedButtonTitle = dateString
            } else {
                section.selectedButtonTitle = nil
            }
        case .duration:
            if let dur = self.dataController?.selectedDuration {
                section.selectedButtonTitle = dur.description
            } else {
                section.selectedButtonTitle = nil
            }
        case .none:
            break
        case .submit:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSubmitTVCell") as? FormSubmitTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: section, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.sections[indexPath.row]
        if section.type == .submit {
            return UITableView.automaticDimension
        }
        return CGFloat(110)
    }
}

extension FindDeskVC: FormTVCellDelegate {
    func didSelectCellButton(withObject object: PageSection) {
        guard let object = object as? FindDeskVCSection else {
            // handle error
            return
        }
        
        switch object.type {
        case .office:
            self.performSegue(withIdentifier: "toChooseTVC", sender: ChooseTVCType.offices)
        case .startTime:
            self.performSegue(withIdentifier: "toDateTimeInputVC", sender: nil)
        case .duration:
            self.performSegue(withIdentifier: "toChooseTVC", sender: ChooseTVCType.duration)
        case .none:
            break
        case .submit:
            if let loading = self.dataController?.isLoading,
                loading == false {
                self.dataController?.submitData()
            }
        }
    }
}

extension FindDeskVC: FindDeskVCDataControllerDelegate {
    func didFindAvailableDesks(desks: [AirDesk]?, error: Error?) {
        if error == nil,
            let desks = desks {
            // fix segue name
            self.performSegue(withIdentifier: "toDeskListVC", sender: desks)
        } else {
            let banner = NotificationBanner(title: "Darn it!", subtitle: "There was an issue loading available desks. Please try again later.", leftView: nil, rightView: nil, style: .danger, colors: nil)
            banner.show()
        }
    }
    
    func startLoadingIndicator() {
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
}

extension FindDeskVC: DateTimeInputVCDelegate {
    func didSaveInput(with date: Date, and identifier: String?) {
        self.dataController?.setSelectedStartDate(with: date)
    }
}

extension FindDeskVC: ChooseTVCDelegate {
    func didSelectOffice(office: AirOffice) {
       self.dataController?.setSelectedOffice(with: office)
    }
    func didSelectDuration(duration: Duration) {
        self.dataController?.setSelectedDuration(with: duration)
    }
}
