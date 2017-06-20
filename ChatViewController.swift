//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Viktorija Anchevska on 10/13/16.
//  Copyright © 2016 Viktorija Anchevska. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ChatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var messageTextField: UITextField!
    var username: String!
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var tableView : UITableView!
    let root = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp")
    var messages: Array<ChatModel>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameLabel.text = username
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        messages = Array<ChatModel>()
        firebaseListener()
        tableView.reloadData()
        //checkUserStatus();
        // Do any additional setup after loading the view.
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func firebaseListener() {
        root.observe(.childAdded, with: {snapshot in
            if let nodeModel = snapshot.value as? Dictionary<String,String> {
                self.messages.append(ChatModel(dict: ["username":nodeModel["username"]!,"message":nodeModel["message"]!]))
                self.tableView.reloadData()
            }
            })
    }
    
    @IBAction func sendClicked(_ sender: AnyObject) {
        let node = root.childByAutoId()
        node.setValue(["username":usernameLabel.text as! NSString,"message":messageTextField.text as! NSString])
    }
    //MARK: Table view methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        cell.setupCellWithModel(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
    

}
