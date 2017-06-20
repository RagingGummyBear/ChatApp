//
//  FriendRequestTableCell.swift
//  ChatApp
//
//  Created by Cool Dude on 10/19/16.
//  Copyright © 2016 Viktorija Anchevska. All rights reserved.
//

import UIKit
import Firebase;
import FirebaseAuth;

class FriendRequestTableCell: UITableViewCell {
    
    @IBOutlet var friendRequestLabel: UILabel!
    @IBOutlet var requestEmailLabel: UILabel!
    @IBOutlet var acceptButton: UIButton!
    @IBOutlet var declineButton: UIButton!
    
    var friendEmail = "";
    var friendKey = "";
    
    var myEmail = "";

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func emailToKey(str: String) -> String{
        return str.replacingOccurrences(of: ".", with: ",");
    }
    
    
    func firebaseListener() {
       
        
        let root1 = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(self.emailToKey(str: self.myEmail))/friendRequests");
        var root2 = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(self.emailToKey(str: self.myEmail))/friends/\(self.emailToKey(str: self.friendEmail))")
        var root3 = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(self.emailToKey(str: self.friendEmail))/friends/\(self.emailToKey(str: self.myEmail))")
                root2.setValue(self.friendEmail);
       
        root3.setValue(self.myEmail);
        
        root1.child(friendKey).setValue(nil);
        
        /*
        root.observe(.childAdded, with: {snapshot in
            if let nodeModel = snapshot.value as? Dictionary<String,String> {
                
                if(nodeModel["email"]! == self.emailToKey(str: self.friendEmail)){
                    
                    
                    
                }
            
            }
            
            
        })
 */
        
    }
    
    
    @IBAction func declineButtonTouchUp(_ sender: AnyObject) {
        
        let root1 = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(self.emailToKey(str: self.myEmail))/friendRequests");

        root1.child(friendKey).setValue(nil);
        
        disableButtons();
        
    }
    
    func disableButtons(){
        acceptButton.isEnabled = false;
        acceptButton.isHidden = true;
        declineButton.isHidden = true;
        declineButton.isEnabled = false;
    }
    
    @IBAction func acceptButtonTouchUp(_ sender: AnyObject) {
 
        self.firebaseListener();
        
        disableButtons();
        
    }

}
