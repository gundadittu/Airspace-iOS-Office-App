//
//  TableSectionHeader.swift
//  AirspaceManagementApp
//
//  Created by Aditya Gunda on 1/4/19.
//  Copyright © 2019 Aditya Gunda. All rights reserved.
//

import UIKit

protocol TableSectionHeaderDelegate {
    func didSelectSectionHeader(with section: PageSection?)
}

class TableSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    var delegate: TableSectionHeaderDelegate?
    var section: PageSection?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TableSectionHeader.didTapHeader(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapHeader(_ gesture: UITapGestureRecognizer) {
        self.delegate?.didSelectSectionHeader(with: self.section)
    }

}
