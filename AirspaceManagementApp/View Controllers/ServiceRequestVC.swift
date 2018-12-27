//
//  ServiceRequestVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 10/15/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import Foundation
import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView
import CFAlertViewController

class ServiceRequestVCSection: PageSection {
    var title = ""
    var buttonTitle = ""
    var selectedButtonTitle: String?
    var type: ServiceRequestVCSectionType = .none
    
    public init(title: String, buttonTitle: String, type: ServiceRequestVCSectionType) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.type = type
    }
}

enum ServiceRequestVCSectionType {
    case location
    case serviceType
    case image
    case note
    case submit
    case none
}

class ServiceRequestVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sections = [ServiceRequestVCSection(title: "There's an issue in", buttonTitle: "Choose Office", type: .location), ServiceRequestVCSection(title: "There's an issue with", buttonTitle: "Choose Issue", type: .serviceType), ServiceRequestVCSection(title: "Add a note (optional)", buttonTitle: "Tell us more", type: .note), ServiceRequestVCSection(title: "Add an image (optional)", buttonTitle: "Choose Image", type: .image), ServiceRequestVCSection(title: "Submit Service Request", buttonTitle: "Submit Service Request", type: .submit)]
    var loadingIndicator: NVActivityIndicatorView?
    var imagePicker = UIImagePickerController()
    var dataController: ServiceRequestVCDataController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Submit a Service Request"
        
        self.tableView.register(UINib(nibName: "FormTVCell", bundle: nil), forCellReuseIdentifier: "FormTVCell")
        self.tableView.register(UINib(nibName: "FormSubmitTVCell", bundle: nil), forCellReuseIdentifier: "FormSubmitTVCell")
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.loadingIndicator = getGlobalLoadingIndicator(in: self.tableView)
        self.view.addSubview(self.loadingIndicator!)
        
        self.dataController = ServiceRequestVCDataController(delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ServiceRequestVCtoChooseTVC",
            let destination = segue.destination as? ChooseTVC {
            destination.type = sender as? ChooseTVCType
            destination.delegate = self
        } else if segue.identifier ==  "ServiceRequestVCtoTextInputVC",
            let destination = segue.destination as? TextInputVC {
            destination.title = "Add a Note"
            destination.delegate = self
            if let note = self.dataController?.note {
                destination.initialText = note
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.row]
        switch section.type {
        case .serviceType:
            if let type = self.dataController?.issueType {
                section.selectedButtonTitle = type.title
            } else {
                section.selectedButtonTitle = nil
            }
        case .location:
            if let office = self.dataController?.selectedOffice {
                section.selectedButtonTitle = office.name
            } else {
                section.selectedButtonTitle = nil
            }
            break
        case .image:
            if let _ = self.dataController?.image {
                section.selectedButtonTitle = "Image added"
            } else {
                section.selectedButtonTitle = nil
            }
        case .none:
            break
        case .note:
            if let note = self.dataController?.note {
                section.selectedButtonTitle = note
            } else {
                section.selectedButtonTitle = nil
            }
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
}

extension ServiceRequestVC: FormTVCellDelegate {
    func didSelectCellButton(withObject object: PageSection) {
        guard let object = object as? ServiceRequestVCSection else {
            // handle error
            return
        }
        
        switch object.type {
        case .location:
            self.performSegue(withIdentifier: "ServiceRequestVCtoChooseTVC", sender: ChooseTVCType.offices)
        case .serviceType:
             self.performSegue(withIdentifier: "ServiceRequestVCtoChooseTVC", sender: ChooseTVCType.serviceRequestType)
        case .image:
            self.showImagePicker()
        case .none:
            return
        case .note:
            self.performSegue(withIdentifier: "ServiceRequestVCtoTextInputVC", sender: nil)
        case .submit:
            self.dataController?.submitFormData()
        }
    }
    
    func showImagePicker() {
        self.imagePicker.delegate = self
        let alert = UIAlertController(title: "Choose Image From", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension ServiceRequestVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            let selectedImage = editedImage
            self.dataController?.setImage(as: selectedImage)
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            let selectedImage = originalImage
            self.dataController?.setImage(as: selectedImage)
            picker.dismiss(animated: true, completion: nil)
        } else {
            self.dataController?.setImage(as: nil)
        }
    }
}

extension ServiceRequestVC: ServiceRequestVCDataControllerDelegate {
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func didFinishSubmittingData(withError error: Error?) {
        if let _ = error {
            let banner = StatusBarNotificationBanner(title: "Error submitting your service request.", style: .danger, colors: nil)
            banner.show()
        } else {
            let alertController = CFAlertViewController(title: "Your service request has been submitted!", message: "We'll get working on your request and keep you updated.", textAlignment: .left, preferredStyle: .alert, didDismissAlertHandler: nil)
            let action = CFAlertAction(title: "Sounds good", style: .Default, alignment: .right, backgroundColor: globalColor, textColor: nil) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(action)
            self.present(alertController, animated: true)
        }
    }
    
    func startLoadingIndicator() {
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
    }
}

extension ServiceRequestVC: ChooseTVCDelegate {
    func didSelectOffice(office: AirOffice) {
        self.dataController?.setSelectedOffice(as: office)
    }
    
    func didSelectSRType(type: ServiceRequestTypeItem) {
        self.dataController?.setIssueType(as: type)
    }
}

extension ServiceRequestVC: TextInputVCDelegate {
    func didSaveInput(with text: String, and identifier: String?) {
        self.dataController?.setNote(as: text)
    }
}
