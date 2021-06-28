//
//  UserTableViewCell.swift
//  TableViewRefresh
//
//  Created by 정성훈 on 2021/06/28.
//


import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static let identifier = "Cell"
    
}
