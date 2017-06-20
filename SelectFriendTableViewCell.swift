//
//  SelectFriendTableViewCell.swift
//  ChatApp
//
//  Created by Cool Dude on 10/21/16.
//  Copyright © 2016 Viktorija Anchevska. All rights reserved.
//

import UIKit

class SelectFriendTableViewCell: UITableViewCell {
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var displayNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
