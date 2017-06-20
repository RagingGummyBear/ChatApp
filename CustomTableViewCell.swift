//
//  CustomTableViewCell.swift
//  ChatApp
//
//  Created by Viktorija Anchevska on 10/13/16.
//  Copyright © 2016 Viktorija Anchevska. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var messageLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellWithModel(model: ChatModel) {
        usernameLabel.text = model.username
        messageLabel.text = model.message
    }

}
