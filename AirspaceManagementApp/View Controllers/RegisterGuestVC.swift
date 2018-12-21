//
//  RegisterGuestVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 11/19/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView
import CFAlertViewController

class RegisterGuestVCSection: PageSection {
    var title = ""
    var buttonTitle = ""
    var selectedButtonTitle: String?
    var type: RegisterGuestVCSectionType = .none
    
    public init(title: String, buttonTitle: String, type: RegisterGuestVCSectionType) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.type = type
    }
}

enum RegisterGuestVCSectionType {
    case office
    case name
    case dateTime
    case email
    case submit
    case none
}

class RegisterGuestVC: UITableViewController {
    var sections = [RegisterGuestVCSection(title: "I have a guest visiting", buttonTitle: "Choose Office", type: .office),RegisterGuestVCSection(title: "Their name is", buttonTitle: "Enter Name", type: .name), RegisterGuestVCSection(title: "They are visiting", buttonTitle: "Choose Date & Time", type: .dateTime), RegisterGuestVCSection(title: "Their email is (optional)", buttonTitle: "Enter Email", type: .email), RegisterGuestVCSection(title: "Submit", buttonTitle: "Register Guest", type: .submit)]
    var dataController: RegisterGuestTVCDataController?
    let datePicker: UIDatePicker = UIDatePicker()
    let tempInput = UITextField( frame:CGRect.zero )
    var loadingIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register a Guest"
        
        self.tableView.register(UINib(nibName: "FormTVCell", bundle: nil), forCellReuseIdentifier: "FormTVCell")
        self.tableView.register(UINib(nibName: "FormSubmitTVCell", bundle: nil), forCellReuseIdentifier: "FormSubmitTVCell")
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        
        self.loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: (self.tableView.frame.width/2)-25, y: (self.tableView.frame.height/2), width: 50, height: 50), type: .ballClipRotate, color: globalColor, padding: nil)
        self.view.addSubview(self.loadingIndicator!)
        
        self.dataController = RegisterGuestTVCDataController(delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegisterGuestVCtoChooseTVC",
            let destination = segue.destination as? ChooseTVC {
            destination.type = sender as? ChooseTVCType
            destination.delegate = self
        } else if segue.identifier == "RegisterGuestVCtoTextInputVC",
            let destination = segue.destination as? TextInputVC,
            let identifier = sender as? String {
            destination.identifier = identifier
            destination.delegate = self
            if identifier == "name" {
                destination.title = "Enter Name"
            } else if identifier == "email" {
                destination.title = "Enter Email"
            }
        } else if segue.identifier == "RegisterGuestVCtoDateTimeInputVC",
            let destination = segue.destination as? DateTimeInputVC {
            destination.delegate = self
            destination.initialDate = self.dataController?.guestVisitDate
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return sections.count
        }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.row]
        switch section.type {
        case .office:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
                return UITableViewCell()
            }
            if let officeName = self.dataController?.selectedOffice?.name {
                section.selectedButtonTitle = officeName
            } else {
                section.selectedButtonTitle = nil
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .submit:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSubmitTVCell") as? FormSubmitTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .name:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
                return UITableViewCell()
            }
            if let guestName = self.dataController?.guestName {
                section.selectedButtonTitle = guestName
            } else {
                section.selectedButtonTitle = nil
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .dateTime:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
                return UITableViewCell()
            }
            if let date = self.dataController?.guestVisitDate {
                section.selectedButtonTitle = date.localizedDescription
            } else {
                section.selectedButtonTitle = nil
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .email:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTVCell") as? FormTVCell else {
                return UITableViewCell()
            }
            if let guestEmail = self.dataController?.guestEmail {
                section.selectedButtonTitle = guestEmail
            } else {
                section.selectedButtonTitle = nil
            }
            cell.configureCell(with: section, delegate: self)
            return cell
        case .none:
            break
        }
        return UITableViewCell()
    }
}

extension RegisterGuestVC: FormTVCellDelegate {
    
    // Delegate from FormTVCell that is called when user clicks on button in cell
    func didSelectCellButton(withObject object: PageSection) {
        // show text field or options to choose data value bassd on object type
        guard let object = object as? RegisterGuestVCSection else {
            // handle error
            return
        }
        
        switch object.type {
        case .office:
            self.performSegue(withIdentifier: "RegisterGuestVCtoChooseTVC", sender: ChooseTVCType.offices)
        case .name:
            self.performSegue(withIdentifier: "RegisterGuestVCtoTextInputVC", sender: "name")
//            self.showGuestNameAlert()
        case .dateTime:
            self.performSegue(withIdentifier: "RegisterGuestVCtoDateTimeInputVC", sender: nil)
//            self.showDatePicker()
        case .email:
            self.performSegue(withIdentifier: "RegisterGuestVCtoTextInputVC", sender: "email")
//            self.showGuestEmailAlert()
        case .submit:
            self.dataController?.submitFormData()
        case .none:
            return
        }
    }
    
//    func showDatePicker() {
//        datePicker.datePickerMode = .dateAndTime
//        datePicker.minimumDate = Date()
//        if let currDate = self.dataController?.guestVisitDate {
//            datePicker.date = currDate
//        }
//
//        let toolbar = UIToolbar();
//        toolbar.sizeToFit()
//
//        let chooseButton = UIBarButtonItem(title: "Choose", style: UIBarButtonItem.Style.plain, target: self, action: #selector(RegisterGuestVC.chooseDatePicker))
//        chooseButton.tintColor = globalColor
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let clearButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItem.Style.plain, target: self, action: #selector(RegisterGuestVC.clearDatePicker))
//        clearButton.tintColor = globalColor
//        toolbar.setItems([clearButton,spaceButton,chooseButton], animated: false)
//
//        tempInput.inputView = datePicker
//        tempInput.inputAccessoryView = toolbar
//        tempInput.inputView = datePicker
//        self.view.addSubview(tempInput)
//        tempInput.becomeFirstResponder()
//    }
//
//    @objc func chooseDatePicker() {
//        self.tempInput.resignFirstResponder()
//        let date = self.datePicker.date
//        self.dataController?.setGuestVistDate(as: date)
//        self.tableView.reloadData()
//    }
//
//    @objc func clearDatePicker() {
//        self.tempInput.resignFirstResponder()
//        self.dataController?.setGuestVistDate(as: nil)
//        self.tableView.reloadData()
//    }
//
//    func showGuestEmailAlert() {
//        let alertController = UIAlertController(title: "What's your guest's email?", message: nil, preferredStyle: .alert)
//
//        //the confirm action taking the inputs
//        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
//            if let email = alertController.textFields?[0].text {
//                self.dataController?.setGuestEmail(as: email)
//                self.tableView.reloadData()
//            } else {
//                let banner = StatusBarNotificationBanner(title: "Error Saving Guest's Email.", style: .danger, colors: nil)
//                banner.show()
//            }
//        }
//
//        //the cancel action doing nothing
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
//
//        //adding textfields to our dialog box
//        alertController.addTextField { (textField) in
//            textField.placeholder = "Your Guest's Email"
//            if let currentText = self.dataController?.guestEmail {
//                textField.text = currentText
//            }
//        }
//
//        //adding the action to dialogbox
//        alertController.addAction(confirmAction)
//        alertController.addAction(cancelAction)
//
//        //finally presenting the dialog box
//        self.present(alertController, animated: true, completion: nil)
//    }
}

extension RegisterGuestVC: ChooseTVCDelegate {
    
    // Delegate function is called when user selects office in ChooseTVC
    func didSelectOffice(office: AirOffice) {
        self.dataController?.setSelectedOffice(as: office)
    }
}

extension RegisterGuestVC: RegisterGuestTVCDataControllerDelegate {
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func toggleLoadingIndicator() {
        guard let la = self.loadingIndicator else { return }
        if la.isAnimating {
            self.loadingIndicator?.stopAnimating()
        } else {
            self.loadingIndicator?.startAnimating()
        }
    }
    
    // Delegate function is called when network request finishes submitting form data
    func didFinishSubmittingData(withError error: Error?) {
        if let _ = error {
            let banner = StatusBarNotificationBanner(title: "Error registering your guest.", style: .danger, colors: nil)
            banner.show()
        } else {
            let alertController = CFAlertViewController(title: "Your guest has been registered!", message: "We'll let you know when they arrive.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
            let action = CFAlertAction(title: "Cool", style: .Default, alignment: .right, backgroundColor: globalColor, textColor: nil) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(action)
            self.present(alertController, animated: true)
        }
    }
}

extension RegisterGuestVC: TextInputVCDelegate {
    func didSaveInput(with text: String, and identifier: String?) {
        if let identifier = identifier {
            if identifier == "name" {
                self.dataController?.setGuestName(as: text)
            } else if identifier == "email" {
                self.dataController?.setGuestEmail(as: text)
            }
        }
    }
}

extension RegisterGuestVC: DateTimeInputVCDelegate {
    func didSaveInput(with date: Date) {
        self.dataController?.setGuestVistDate(as: date)
    }
}
