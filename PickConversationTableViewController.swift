//
//  PickConversationTableViewController.swift
//  ChatApp
//
//  Created by Cool Dude on 10/21/16.
//  Copyright © 2016 Viktorija Anchevska. All rights reserved.
//

import UIKit
import Firebase;
import FirebaseAuth;

class PickConversationTableViewController: UITableViewController {
    
    
    var conversations = [String:String]();
    var conversationsArray = [String]();
    var myEmail = "";
    var userDisplayName = "";


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                
                self.myEmail = user.email!;
                //self.userDisplayName = user.displayName!;
                 self.getAllConversations();
                
                let node = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(self.emailToKey(str: user.email!))/userDisplayName");
                
                node.observeSingleEvent(of: .value, with: {snapshot2 in
                    
                    self.userDisplayName = (snapshot2.value as? String)! ;
                    
                    
                });

                
            } else {
                
            }
        }
        
       
        
    }
    
    
    func emailToKey(str: String) -> String{
        return str.replacingOccurrences(of: ".", with: ",");
    }
    
    func getAllConversations(){
        
        
        var conversationName = "";
        let root = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(self.emailToKey(str: self.myEmail))/conversations");
        
        root.observe(.childAdded, with: {snapshot in
            
           // conversationName = snapshot.childSnapshot(forPath: "ConversationName").value as! String;
           // self.conversations[snapshot.key] = conversationName;
            self.conversations[snapshot.childSnapshot(forPath: "ConversationKey").value as! String] = snapshot.childSnapshot(forPath: "ConversationName").value as! String;
            
            //self.conversationsArray.append(conversationName);
            /*
             if let nodeModel = snapshot.value as? Dictionary<String,String> {
             
             if self.allRequests[nodeModel["email"]!] != nil {
             //snapshot.setValue(nil);
             self.array.append(snapshot.key);
             }
             else {
             self.allRequests[nodeModel["email"]!] = snapshot.key;
             
             self.tableView.reloadData();
             }
             
             }
             */
            self.tableView.reloadData();
            
        })
        
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SignOutSegueIdentifier")
        {
            try! FIRAuth.auth()!.signOut()
            if let storyboard = self.storyboard {
               // let vc = storyboard.instantiateViewController(withIdentifier: "firstNavigationController") as! UINavigationController
               // self.present(vc, animated: false, completion: nil)
            }
        }
        else {
        var destination = segue.destination as? ConversationTableViewController;
        if(destination != nil){
        destination?.conversationKey = Array(conversations .keys)[(self.tableView.indexPathForSelectedRow?.row)!];
        destination?.myEmail = self.myEmail;
        destination?.conversationName = conversations[Array(conversations .keys)[(self.tableView.indexPathForSelectedRow?.row)!]]!;
            destination?.senderDisplayName = self.userDisplayName;
        }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return conversations.count;

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickConversationTableCellIndentifiwer", for: indexPath) as! PickConversationTableViewCell

        
        cell.conversationKey = Array(conversations .keys)[indexPath.row];
        cell.conversationNameLabel.text = conversations[Array(conversations .keys)[indexPath.row]];
    
        
        
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
