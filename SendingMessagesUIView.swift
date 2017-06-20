//
//  SendingMessagesUIView.swift
//  ChatApp
//
//  Created by Cool Dude on 10/22/16.
//  Copyright © 2016 Viktorija Anchevska. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SendingMessagesUIView: UIViewController {

    var conversationKey = "";
    var senderDisplayName = "";
    
    @IBOutlet var MessageInputTextField: UITextField!
  
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func buttonTouchUpInside(_ sender: AnyObject) {
    
        if(MessageInputTextField.text != ""){
        var root = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allConversations/\(self.conversationKey)/allMessages");
        root = root.childByAutoId();
        root.setValue(["displayName" : self.senderDisplayName, "message" : MessageInputTextField.text!]);
            }
        
    }

    
}
