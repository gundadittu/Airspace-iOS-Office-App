//
//  DeskListVC.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 12/28/18.
//  Copyright © 2018 Aditya Gunda. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftPullToRefresh
import DZNEmptyDataSet

class DeskListVC: UITableViewController {
    
    var hotDesks = [AirDesk]()
    var startingDate = Date()
    var dataController: FindDeskVCDataController?
    var loadingIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hot Desks"
        
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "ConferenceRoomTVCell", bundle: nil), forCellReuseIdentifier: "ConferenceRoomTVCell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(didClickFilter))
        
        self.loadingIndicator = getGlobalLoadingIndicator(in: self.tableView)
        self.view.addSubview(self.loadingIndicator!)
        
        self.tableView.spr_setTextHeader { [weak self] in
            self?.dataController?.submitData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @objc func didClickFilter() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotDesks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ConferenceRoomTVCell", for: indexPath) as? ConferenceRoomTVCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: self.hotDesks[indexPath.row], startingAt: self.dataController?.selectedStartDate ?? Date(), delegate: self)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "toHotDeskProfileVC", sender: self.hotDesks[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHotDeskProfileVC",
            let destination = segue.destination as? HotDeskProfileVC,
            let desk = sender as? AirDesk {
            destination.hotDesk = desk
            
            // auto-populate fields if applicable
            if let dataController = self.dataController,
                let startDate = dataController.selectedStartDate,
                let _ = dataController.selectedDuration?.rawValue,
                let endDate = dataController.getEndDate() {
                destination.startDate = startDate
                destination.endDate = endDate
            }
        }
    }
    
}

extension DeskListVC: ConferenceRoomTVCellDelegate {
    func didSelectCollectionView(for desk: AirDesk) {
         self.performSegue(withIdentifier: "toHotDeskProfileVC", sender: desk)
    }
    
    func didSelectCollectionView(for room: AirConferenceRoom) {
       return
    }
}

extension DeskListVC: FindDeskVCDataControllerDelegate {
    func didFindAvailableDesks(desks: [AirDesk]?, error: Error?) {
        if let desks = desks {
            self.hotDesks = desks
            self.tableView.reloadData()
        } else {
            // handle error
            return
        }
    }
    
    func startLoadingIndicator() {
        self.loadingIndicator?.startAnimating()
    }
    
    func stopLoadingIndicator() {
        self.loadingIndicator?.stopAnimating()
        self.tableView.spr_endRefreshing()
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
}

extension DeskListVC: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if let isLoading = self.dataController?.isLoading,
            isLoading == true {
            let attributedString = NSMutableAttributedString(string: "", attributes: globalTextAttrs)
            return attributedString
        } else {
            return NSMutableAttributedString(string: "No desks!", attributes: globalTextAttrs)
        }
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if let isLoading = self.dataController?.isLoading,
            isLoading == true {
            let attributedString = NSMutableAttributedString(string: "", attributes: globalTextAttrs)
            return attributedString
        } else {
            return NSMutableAttributedString(string: "Even Indiana Jones couldn't find anything with that criteria.", attributes: globalTextAttrs)
        }
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if let isLoading = self.dataController?.isLoading,
            isLoading == true {
            return UIImage()
        } else {
            return UIImage(named: "indiana")
        }
    }
}
