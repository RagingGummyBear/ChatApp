//
//  ViewController.swift
//  ChatApp
//
//  Created by Viktorija Anchevska on 10/13/16.
//  Copyright © 2016 Viktorija Anchevska. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class ViewController: UIViewController {
    
    @IBOutlet var emailUITextView: UITextField!

    @IBOutlet var passwordUITextView: UITextField!

    @IBOutlet var beginChattingButton: UIButton!
    var isLoggedIn = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        checkUserStatus();
    }

    func checkUserStatus(){
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {

                let root = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(self.emailToKey(str: user.email!))/conversations");
                //root.setValue(["message":"cool cool", "another thingy":"cool cool"]);
                self.isLoggedIn = true;
                self.beginChattingButton.sendActions(for: UIControlEvents.touchUpInside);
            } else {
                self.isLoggedIn = false;
                            }
        }
        
    }
    
    func emailToKey(str: String) -> String{
        return str.replacingOccurrences(of: ".", with: ",");
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        
        if(identifier == "registrationSegueIdentifier")
        {
            return true;
        }
        
        if (isLoggedIn){return true;}
        else
        {
            FIRAuth.auth()?.signIn(withEmail: self.emailUITextView.text!, password: self.passwordUITextView.text!, completion: { (user, error) in
                if (user != nil){
                    
                    self.isLoggedIn = true;
                }
                else
                {
                    let ac = UIAlertController(title: "Unable to sign in", message: error?.localizedDescription, preferredStyle: .alert);
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
                    self.present(ac, animated: true, completion: nil);
                    self.isLoggedIn = false;
                }
            })
            
            
            return isLoggedIn;
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatSegue" {
            
        }
    }


}

