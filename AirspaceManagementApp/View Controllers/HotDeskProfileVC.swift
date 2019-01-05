//
//  HotDeskProfileVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/28/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftPullToRefresh
import CFAlertViewController


enum HotDeskProfileSectionType {
    case bio
    case createCalendarEvent
    case submit
    case none
}

class HotDeskProfileSection : PageSection {
    var title = ""
    var buttonTitle = ""
    var selectedButtonTitle: String?
    var type: HotDeskProfileSectionType = .none
    
    public init(title: String, buttonTitle: String?, type: HotDeskProfileSectionType) {
        self.title = title
        self.type = type
        self.buttonTitle = buttonTitle ?? ""
    }
}

class HotDeskProfileVC: UIViewController {
    var sections = [HotDeskProfileSection(title: "Bio", buttonTitle: nil, type: .bio), HotDeskProfileSection(title: "", buttonTitle: nil, type: .createCalendarEvent), HotDeskProfileSection(title: "Reserve Desk", buttonTitle: "Reserve Desk", type: .submit)]
    var loadingIndicator: NVActivityIndicatorView?
    var dataController: HotDeskProfileDataController?
    
    var hotDesk: AirDesk?
    var existingResDisplayStartDate = Date() // date used to display existing reservations for room
    var startDate: Date?
    var endDate: Date?
    var didPull = false
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hot Desk Profile"
        self.tableView.register(UINib(nibName: "ConferenceRoomDetailedTVC", bundle: nil), forCellReuseIdentifier: "ConferenceRoomDetailedTVC")
        self.tableView.register(UINib(nibName: "FormSubmitTVCell", bundle: nil), forCellReuseIdentifier: "FormSubmitTVCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        
        let loadingIndicator = getGlobalLoadingIndicator(in: self.view)
        self.loadingIndicator = loadingIndicator
        self.view.addSubview(loadingIndicator)
        
        self.tableView.addSubview(self.loadingIndicator!)
        
        self.tableView.spr_setTextHeader { [weak self] in
            self?.didPull = true
            self?.tableView.reloadData()
        }
        
        guard let hotDesk = self.hotDesk else {
            fatalError("Did not provide hotDesk object for HotDeskProfileVC.")
        }
        
        if self.dataController == nil {
            self.dataController = HotDeskProfileDataController(delegate: self)
        }
        self.dataController?.setHotDesk(with: hotDesk)
        if let startDate = self.startDate {
            self.existingResDisplayStartDate = startDate.getBeginningOfDay ?? Date()
            self.dataController?.setSelectedStartDate(with: startDate)
        }
        if let endDate = self.endDate {
            self.dataController?.setSelectedEndDate(with: endDate)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDateInputVC",
            let destination = segue.destination as? DateTimeInputVC,
            let identifier = sender as? String {
            destination.delegate = self
            destination.identifier = identifier

            if (identifier == "chooseReservationDate") {
                destination.mode = .date
                destination.minimumDate = Date()
                destination.initialDate = self.existingResDisplayStartDate
            } else if (identifier == "chooseStartDate") {
                destination.mode = .time

                if let initialDate = self.dataController?.selectedStartDate {
                    destination.initialDate = initialDate
                } else {
                    destination.initialDate = self.existingResDisplayStartDate
                }

            } else if (identifier == "chooseEndDate") {
                destination.mode = .time

                if let startDate = self.dataController?.selectedStartDate {
                    destination.minimumDate = startDate
                }

                if let initialDate = self.dataController?.selectedEndDate {
                    destination.initialDate = initialDate
                } else {
                    destination.initialDate = self.existingResDisplayStartDate
                }

            }
        }
    }
}

extension HotDeskProfileVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section.type {
        case .bio:
            break
        case .createCalendarEvent:
            break
        case .submit:
            break
        case .none:
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section.type {
        case .bio:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ConferenceRoomDetailedTVC", for: indexPath) as? ConferenceRoomDetailedTVC,
                let hotDesk = self.hotDesk else {
                    return UITableViewCell()
            }
            cell.configureCell(with: hotDesk, for: existingResDisplayStartDate, newReservationStartDate: self.dataController?.selectedStartDate, newReservationEndDate: self.dataController?.selectedEndDate)
            cell.setDelegate(with: self)
            return cell
        case .createCalendarEvent:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as? DeskSwitchCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            self.dataController?.setShouldCreateCalendarEvent(with: cell.switchBtn.isOn)
            return cell
        case .submit:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSubmitTVCell") as? FormSubmitTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HotDeskProfileVC: FormTVCellDelegate {
    func didSelectCellButton(withObject object: PageSection) {
        // Did select submit button
        guard let object = object as? HotDeskProfileSection else { return }
        switch object.type {
        case .bio:
            break
        case .createCalendarEvent:
            break
        case .submit:
           self.dataController?.submitData()
        case .none:
            break
        }
    }
}

extension HotDeskProfileVC: ConferenceRoomDetailedTVCDelegate, HotDeskProfileDataControllerDelegate {
    func didTapWhenDateButton() {
        // clicked when date button -> show date picker
        self.performSegue(withIdentifier: "toDateInputVC", sender: "chooseReservationDate")
    }
    
    func didTapStartDateButton() {
        self.performSegue(withIdentifier: "toDateInputVC", sender: "chooseStartDate")
    }
    
    func didTapEndDateButton() {
        self.performSegue(withIdentifier: "toDateInputVC", sender: "chooseEndDate")
    }
    
    func startLoadingIndicator() {
        if self.didPull == true {
            return
        }
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
        self.tableView.spr_endRefreshing()
    }
    
    func didChooseNewDates(start: Date, end: Date) {
        self.dataController?.setSelectedStartDate(with: start)
        self.dataController?.setSelectedEndDate(with: end)
    }
    
    func didFindConflict() {
        let alertController = CFAlertViewController(title: "Oh no!", message: "This desk is not available during the selected time frame.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
        let action = CFAlertAction(title: "Ok 😕", style: .Default, alignment: .justified, backgroundColor: globalColor, textColor: .black, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
    
    func didFinishSubmittingData(withError error: Error?) {
        self.didPull = false
        if let _ = error {
            let alertController = CFAlertViewController(title: "Oh no!🤯", message: "There was an issue reserving this desk.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
            
            let action = CFAlertAction(title: "Ok", style: .Default, alignment: .justified, backgroundColor: .red, textColor: .black, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true)
        } else {
            let alertController = CFAlertViewController(title: "Blast off! 🚀", message: "Your reservation is confirmed.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
            let action = CFAlertAction(title: "Great!", style: .Default, alignment: .justified, backgroundColor: globalColor, textColor: nil) { (action) in
                
                // pops back to ReserveVC or MainVC based on origin
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ReserveVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                    } else if controller.isKind(of: MainVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                    }
                }
                NotificationManager.shared.requestPermission()
            }
            alertController.addAction(action)
            self.present(alertController, animated: true)
        }
    }
    
    func reloadTableView() {
        let indexSet = IndexSet(integersIn: 1..<self.sections.count)
        self.tableView.reloadSections(indexSet, with: .none)
    }
}

extension HotDeskProfileVC: DateTimeInputVCDelegate {
    func didSaveInput(with date: Date, and identifier: String?) {
        if identifier == "chooseReservationDate" {
            self.existingResDisplayStartDate = date
            
            self.dataController?.setSelectedStartDate(with: nil)
            self.dataController?.setSelectedEndDate(with: nil)
            
            //need to clear old selection
            self.startDate = nil
            self.endDate = nil
            
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
        } else if identifier == "chooseStartDate" {
            self.startDate = nil
            self.dataController?.setSelectedStartDate(with: date)
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
        } else if identifier == "chooseEndDate" {
            self.endDate = nil
            self.dataController?.setSelectedEndDate(with: date)
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
        }
    }
    
    func changeInDate(interval: TimeInterval, and identifier: String?) {
        //auto increase end date after increasing start date
        if identifier == "chooseStartDate" {
            if let currEndDate = self.dataController?.selectedEndDate {
                let newEndDate = currEndDate.addingTimeInterval(interval)
                self.dataController?.setSelectedEndDate(with: newEndDate)
            }
        }
    }
}

extension HotDeskProfileVC: DeskSwitchCellDelegate {
    func didChangeSwitchValue(to value: Bool) {
        self.dataController?.setShouldCreateCalendarEvent(with: value)
    }
}

protocol DeskSwitchCellDelegate  {
    func didChangeSwitchValue(to value: Bool)
}

class DeskSwitchCell: UITableViewCell {
    
    @IBOutlet weak var switchBtn: UISwitch!
    var delegate: DeskSwitchCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.switchBtn.onTintColor = globalColor
    }
    
    @IBAction func switchBtnToggled(_ sender: Any) {
        guard let sender = sender as? UISwitch else { return }
        self.delegate?.didChangeSwitchValue(to: sender.isOn)
    }
    
}
