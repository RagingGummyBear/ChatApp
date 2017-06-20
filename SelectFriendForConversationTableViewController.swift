//
//  SelectFriendForConversationTableViewController.swift
//  ChatApp
//
//  Created by Cool Dude on 10/21/16.
//  Copyright © 2016 Viktorija Anchevska. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SelectFriendForConversationTableViewController: UITableViewController {

    var friends = [String:String](); //email : displayName
    var myEmail = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                
                self.myEmail = user.email!;
                self.getAllFriends();
                
            } else {
                
            }
        }
        
        
    }
    
    
    func getAllFriends(){
        
        
        var friendsEmail = "";
        let root = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(self.emailToKey(str: self.myEmail))/friends");
        var node = root;
        var emails = [String]();
        root.observe(.childAdded, with: {snapshot in
            
            friendsEmail = snapshot.value as! String;
            emails.append(friendsEmail);
            
            node = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(self.emailToKey(str: friendsEmail))/userDisplayName");
            
            node.observeSingleEvent(of: .value, with: {snapshot2 in
                
                self.friends[snapshot.key] = snapshot2.value as? String ;
                self.tableView.reloadData();
                
            });
 
            
            
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func emailToKey(str: String) -> String{
        return str.replacingOccurrences(of: ".", with: ",");
    }
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return tableView.indexPathForSelectedRow?.row != nil;
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         var root = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allConversations/");
        root = root.childByAutoId();
        root.setValue(["conversationName" : "\(self.myEmail) started conversation"]);
   
        let userConversation = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(self.emailToKey(str: self.myEmail))/conversations");
        let friendConversation = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(self.emailToKey(str: Array(self.friends .keys)[(self.tableView.indexPathForSelectedRow?.row)!] ))/conversations");
        userConversation.childByAutoId().setValue(["ConversationKey" : root.key , "ConversationName" : Array(self.friends .keys)[(self.tableView.indexPathForSelectedRow?.row)!]] );
        friendConversation.childByAutoId().setValue(["ConversationKey" : root.key , "ConversationName" : self.myEmail] );
        
        var destination = segue.destination as! ConversationTableViewController;
        destination.conversationKey = root.key;
        destination.conversationName = Array(self.friends .keys)[(self.tableView.indexPathForSelectedRow?.row)!];
        destination.myEmail = self.myEmail;
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectFriendTableCellIdentifier", for: indexPath) as! SelectFriendTableViewCell
        
        cell.emailLabel.text = Array(self.friends .keys)[(indexPath.row)];
        cell.displayNameLabel.text = self.friends[Array(self.friends .keys)[(indexPath.row)]];
        
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
