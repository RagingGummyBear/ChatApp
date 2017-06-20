//
//  friendRequesttableViewController.swift
//  ChatApp
//
//  Created by Cool Dude on 10/19/16.
//  Copyright © 2016 Viktorija Anchevska. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class friendRequesttableViewController: UITableViewController {

    var array = Array<String>();
    var allRequests = [String: String]();
    var myEmail = "";
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                
                self.myEmail = user.email!;
                self.firebaseListener();
                
            } else {
                print("Well the user is nil :D")
            }
        }
        
        firebaseListener();
self.tableView.reloadData();
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return Array(allRequests .keys).count;
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func emailToKey(str: String) -> String{
        return str.replacingOccurrences(of: ".", with: ",");
    }
    
    func firebaseListener() {
        let root = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(self.emailToKey(str: self.myEmail))/friendRequests");
        root.observe(.childAdded, with: {snapshot in
            if let nodeModel = snapshot.value as? Dictionary<String,String> {
                
                self.array.append(nodeModel["email"]!);
                //print("something : \(nodeModel["email"]!) and : \(snapshot.key)");
                self.allRequests[nodeModel["email"]!] = snapshot.key;
                //print("In this hell : \(self.array.count)");
                //self.messages.append(ChatModel(dict: ["username":nodeModel["username"]!,"message":nodeModel["message"]!]))
                self.tableView.reloadData();
            }
        })
    }
    


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("testin");
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestOnlyTableCellIdentifier", for: indexPath) as! FriendRequestTableCell
        
        cell.friendRequestLabel.text = "\(array[indexPath.row] ) wants to add you as friend";
        cell.friendRequestLabel.text = "\(Array(allRequests .keys)[indexPath.row]) wants to add you as friend :D ";
        cell.friendEmail = Array(allRequests .keys)[indexPath.row];
        cell.friendKey = allRequests[cell.friendKey]!;
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
