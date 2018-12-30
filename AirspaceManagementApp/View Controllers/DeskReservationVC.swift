//
//  DeskReservationVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/29/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CFAlertViewController
import NotificationBannerSwift

class DeskReservationVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var sections = [DeskReservationVCSection(title: "Bio", buttonTitle: nil, type: .bio), DeskReservationVCSection(title: "Save Changes", buttonTitle: "", type: .saveChanges), DeskReservationVCSection(title: "Cancel Reservation", buttonTitle: "", type: .cancelReservation)]
    
    var loadingIndicator: NVActivityIndicatorView?
    var dataController: DeskReservationVCDataController?
    var hotDeskReservation: AirDeskReservation?
    var existingResDisplayStartDate = Date() // date used to display existing reservations for room
    var modificationsAllowed = true
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "ConferenceRoomDetailedTVC", bundle: nil), forCellReuseIdentifier: "ConferenceRoomDetailedTVC")
        self.tableView.register(UINib(nibName: "FormSubmitTVCell", bundle: nil), forCellReuseIdentifier: "FormSubmitTVCell")
        self.tableView.register(UINib(nibName: "SeeMoreTVC", bundle: nil), forCellReuseIdentifier: "SeeMoreTVC")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        
        self.loadingIndicator = getGlobalLoadingIndicator(in: self.tableView)
        self.tableView.addSubview(self.loadingIndicator!)
        
        self.title = "My Desk Reservation"
        
        self.tableView.spr_setTextHeader { [weak self] in
            self?.tableView.reloadData()
        }
        
        guard let reservation = self.hotDeskReservation else {
            fatalError("Did not provide hotDeskReservation object for DeskReservationVC.")
        }
        self.configureSections()
        
        if self.dataController == nil {
            self.dataController = DeskReservationVCDataController(delegate: self)
        }
        self.dataController?.setHotDeskReservation(with: reservation)
        self.existingResDisplayStartDate = reservation.startingDate?.getBeginningOfDay ?? Date()
    }
    
    func configureSections() {
        guard let reservation = self.hotDeskReservation,
            let endDate = reservation.endDate else {
                fatalError("Did not provide hotDeskReservation object for ConferenceRoomProfileTVC.")
        }
        
        if endDate < Date() {
            self.sections = [DeskReservationVCSection(title: "Bio", buttonTitle: nil, type: .bio)]
            self.modificationsAllowed = false
        } else {
            self.sections = [DeskReservationVCSection(title: "Bio", buttonTitle: nil, type: .bio), DeskReservationVCSection(title: "Save Changes", buttonTitle: "", type: .saveChanges), DeskReservationVCSection(title: "Cancel Reservation", buttonTitle: "", type: .cancelReservation)]
            self.modificationsAllowed = true
        }
        self.tableView.reloadData()
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

extension DeskReservationVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section.type {
        case .bio:
            return 1
        case .cancelReservation:
            return 1
        case .saveChanges:
            return 1
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section.type {
        case .bio:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ConferenceRoomDetailedTVC", for: indexPath) as? ConferenceRoomDetailedTVC else {
                return UITableViewCell()
            }
            
            if let desk = self.dataController?.hotDesk {
                let start = self.existingResDisplayStartDate
                cell.hotDeskReservation = self.hotDeskReservation
                cell.configureCell(with: desk, for: start, newReservationStartDate: self.dataController?.selectedStartDate, newReservationEndDate: self.dataController?.selectedEndDate)
            }
            cell.setDelegate(with: self)
            return cell
        case .cancelReservation:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeeMoreTVC") as? SeeMoreTVC else {
                return UITableViewCell()
            }
            cell.sectionObj = section
            cell.delegate = self
            cell.button.layer.borderWidth = CGFloat(0)
            cell.button.setTitle("Cancel Reservation", for: .normal)
            cell.button.setTitleColor(.red, for: .normal)
            return cell
        case .saveChanges:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSubmitTVCell") as? FormSubmitTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DeskReservationVC: FormTVCellDelegate {
    // did click save changes
    func didSelectCellButton(withObject object: PageSection) {
        guard let object = object as? DeskReservationVCSection else { return }
        switch object.type {
        case .bio:
            return
        case .none:
            return
        case .cancelReservation:
            return
        case .saveChanges:
            self.dataController?.submitData()
        }
    }
}

extension DeskReservationVC: ConferenceRoomDetailedTVCDelegate {
    func didTapWhenDateButton() {
        if self.modificationsAllowed == false {
            return
        }
        self.performSegue(withIdentifier: "toDateInputVC", sender: "chooseReservationDate")
    }
    
    func didTapStartDateButton() {
        if self.modificationsAllowed == false {
            return
        }
        self.performSegue(withIdentifier: "toDateInputVC", sender: "chooseStartDate")
    }
    
    func didTapEndDateButton() {
        if self.modificationsAllowed == false {
            return
        }
        self.performSegue(withIdentifier: "toDateInputVC", sender: "chooseEndDate")
    }
    
    func didChooseNewDates(start: Date, end: Date) {
        if self.modificationsAllowed == false {
            return
        }
        self.dataController?.setSelectedStartDate(with: start)
        self.dataController?.setSelectedEndDate(with: end)
    }
    
    func didFindConflict() {
        let alertController = CFAlertViewController(title: "Oh no!", message: "This hot desk is not available during the selected time frame.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
        let action = CFAlertAction(title: "Ok 😕", style: .Default, alignment: .justified, backgroundColor: globalColor, textColor: .black, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
    
    
}

extension DeskReservationVC: SeeMoreTVCDelegate {
    func didSelectSeeMore(for section: PageSection) {
        // did click cancel
        self.handleCancellation()
    }
    
    func handleCancellation() {
        let alertController = CFAlertViewController(title: "Watch out!😱", message: "Are you sure you want to cancel your reservation? This action is permanent.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
        let action = CFAlertAction(title: "Cancel Reservation", style: .Destructive, alignment: .justified, backgroundColor: .flatRed, textColor: nil) { (action) in
            self.cancelReservation()
        }
        let secondAction = CFAlertAction(title: "No, don't cancel it.", style: .Default, alignment: .justified, backgroundColor: globalColor, textColor: nil, handler: nil)
        alertController.addAction(action)
        alertController.addAction(secondAction)
        self.present(alertController, animated: true)
    }
    
    func cancelReservation() {
        let errorAlertController = CFAlertViewController(title: "Oh no!", message: "We couldn't cancel your reservation. Please try again later.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
        let action = CFAlertAction(title: "Ok 😕", style: .Default, alignment: .justified, backgroundColor: globalColor, textColor: .black, handler: nil)
        errorAlertController.addAction(action)
        
        guard let uid = self.dataController?.originalReservation?.uid else {
            self.present(errorAlertController, animated: true)
            return
        }
        self.loadingIndicator?.startAnimating()
        DeskReservationManager.shared.cancelHotDeskReservation(reservationUID: uid) { (error) in
            self.loadingIndicator?.stopAnimating()
            if let _ = error {
                self.present(errorAlertController, animated: true)
            } else {
                let alertController = CFAlertViewController(title: "Good News!", message: "Your reservation was canceled.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
                let action = CFAlertAction(title: "Sounds good", style: .Default, alignment: .justified, backgroundColor: globalColor, textColor: .black) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(action)
                self.present(alertController, animated: true)
            }

        }
    }
}

extension DeskReservationVC: DeskReservationVCDataControllerDelegate {
    func didFinishSubmittingData(withError error: Error?) {
        if let _ = error {
            let banner = NotificationBanner(title: "Woops!", subtitle: "We are unable to modify your reservation currently. Try again later.", leftView: nil, rightView: nil, style: .warning, colors: nil)
            banner.show()
        } else {
            let alertController = CFAlertViewController(title: "Get Working!🤟🏼 ", message: "Your reservation has been updated.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
            
            let action = CFAlertAction(title: "Sounds Good", style: .Default, alignment: .justified, backgroundColor: globalColor, textColor: nil) { (action) in
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ReserveVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
            alertController.addAction(action)
            self.present(alertController, animated: true)
        }
    }
    
    func startLoadingIndicator() {
        self.showActivityIndicator()
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.hideActivityIndicator()
        self.loadingIndicator?.stopAnimating()
        self.tableView.spr_endRefreshing()
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
}

extension DeskReservationVC: DateTimeInputVCDelegate {
    func didSaveInput(with date: Date, and identifier: String?) {
        if identifier == "chooseReservationDate" {
            self.existingResDisplayStartDate = date
            
            if date.getBeginningOfDay == self.dataController?.originalReservation?.startingDate?.getBeginningOfDay,
                (self.dataController?.selectedStartDate == nil || self.dataController?.selectedEndDate == nil) {
                self.dataController?.updateToOriginalTimes()
            } else {
                self.dataController?.setSelectedStartDate(with: nil)
                self.dataController?.setSelectedEndDate(with: nil)
            }
            
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
        } else if identifier == "chooseStartDate" {
            self.dataController?.setSelectedStartDate(with: date)
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
        } else if identifier == "chooseEndDate" {
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
