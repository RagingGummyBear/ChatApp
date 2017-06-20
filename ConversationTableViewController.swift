//
//  ConversationTableViewController.swift
//  ChatApp
//
//  Created by Cool Dude on 10/21/16.
//  Copyright © 2016 Viktorija Anchevska. All rights reserved.
//

import UIKit
import Firebase;
import FirebaseAuth;

class ConversationTableViewController: UITableViewController {
  
    var myEmail = "";
    var conversationKey = "";
    var conversationName = "";
    var senderDisplayName = "not implemented";
    
    @IBOutlet var sendingMsgUIView: UIView!
    var conversationMessages = [ChatModel]();
    
    @IBOutlet var conversationNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
       
        conversationNameLabel.text = conversationName;
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        
   
        setConversationListener();
        

        
    }
    
    func setConversationListener()
    {
       
        var root = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allConversations/\(self.conversationKey)/allMessages");
        
        root.observe(.childAdded, with: {snapshot in
                if let nodeModel = snapshot.value as? Dictionary<String,String> {
                    //self.messages.append(ChatModel(dict: ["displayName":nodeModel["displayName"]!,"message":nodeModel["message"]!]))
                    self.conversationMessages.append(ChatModel(displayName: nodeModel["displayName"]!, message: nodeModel["message"]!));
                    
                    self.tableView.reloadData();
                    
                    self.tableView.scrollToRow(at: NSIndexPath(row : self.conversationMessages.count - 1, section : 0) as IndexPath, at: UITableViewScrollPosition.middle, animated: false)
                   
                
                    //self.tableView.scrollToRow(at: <#T##IndexPath#>, at: <#T##UITableViewScrollPosition#>, animated: <#T##Bool#>)
                    
                }
            })
        
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
        return conversationMessages.count;
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currentConversationTableViewCellIdentifier", for: indexPath) as! ConversationTableViewCell
        
        cell.messageLabel?.text = "\(conversationMessages[indexPath.row].username!) : \(conversationMessages[indexPath.row].message!)";
        
        // Configure the cell...

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let msgView = segue.destination as? SendingMessagesUIView {
            msgView.conversationKey = self.conversationKey;
            msgView.senderDisplayName = self.senderDisplayName;
        }
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
