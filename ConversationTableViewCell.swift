//
//  ConversationTableViewCell.swift
//  ChatApp
//
//  Created by Cool Dude on 10/21/16.
//  Copyright © 2016 Viktorija Anchevska. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
    @IBOutlet var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
