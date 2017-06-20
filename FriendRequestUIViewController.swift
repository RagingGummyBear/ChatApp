//
//  FriendRequestUIViewController.swift
//  ChatApp
//
//  Created by Cool Dude on 10/18/16.
//  Copyright © 2016 Viktorija Anchevska. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class FriendRequestUIViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
 
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var requestUserEmailUITextField: UITextField!
    var myEmail = "";
    var array = Array<String>();
    var allRequests = [String: String]();
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 105
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
              
                self.myEmail = user.email!;
                self.firebaseListener();
                self.tableView.reloadData();
            
            } else {
                
            }
        }
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func emailToKey(str: String) -> String{
        return str.replacingOccurrences(of: ".", with: ",");
    }
    
    @IBAction func addUserButtonTouched(_ sender: AnyObject) {
        
        if(isValidEmail(testStr: requestUserEmailUITextField.text!)){
            let root = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(self.emailToKey(str: self.requestUserEmailUITextField.text!))");
            root.queryOrderedByKey().observeSingleEvent(of: .childAdded, with: { (snapshot) in
                //print("snapshot value : \(snapshot.value)" );
                var node = root.child("friendRequests");
                node = node.childByAutoId();
                node.setValue(["email":self.myEmail]);
            })

        }
        
    }

    
   
    
    func firebaseListener() {
        let root = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(self.emailToKey(str: self.myEmail))/friendRequests");
        root.observe(.childAdded, with: {snapshot in
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
            
            
            for key in self.array {
                root.child(key).setValue(nil);
            }
            
        })
    }
    
    

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("testin");
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestTableCellIdentifier", for: indexPath) as! FriendRequestTableCell
        
        
            
        cell.requestEmailLabel.text = "\(Array(allRequests .keys)[indexPath.row]) wants to add you as friend :D ";
            cell.friendEmail = Array(allRequests .keys)[indexPath.row];
            cell.friendKey = allRequests[Array(allRequests .keys)[indexPath.row]]!;
            cell.myEmail = self.myEmail;
            
        
        // Configure the cell...
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Array(allRequests .keys).count;
    }
    /*
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
 */
    
    
}
