//
//  UserRegistrationUiViewController.swift
//  ChatApp
//
//  Created by Cool Dude on 10/18/16.
//  Copyright © 2016 Viktorija Anchevska. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserRegistrationUiViewController: UIViewController {
    
    @IBOutlet var emailUITextField: UITextField!
    @IBOutlet var displayUITextField: UITextField!
    @IBOutlet var passwordUITextField: UITextField!
    @IBOutlet var rePasswordUITextField: UITextField!
    var myMail = "";

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func registerButtonTouchUp(_ sender: AnyObject) {
        
        if(!isValidEmail(testStr: emailUITextField.text!)){
            let ac = UIAlertController(title: "Invaild email", message: "Please enter a vaild email address", preferredStyle: .alert);
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
            present(ac, animated: true, completion: nil);
            return;
        }
        
        if(!(passwordUITextField.text == rePasswordUITextField.text)){
            let ac = UIAlertController(title: "Invaild passwords", message: "The passwords don't match", preferredStyle: .alert);
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
            present(ac, animated: true, completion: nil);
            return;

        }
        
        FIRAuth.auth()?.createUser(withEmail: emailUITextField.text!, password: passwordUITextField.text!) { (user, error) in

            
            if(user == nil){
                let ac = UIAlertController(title: "There was an error", message: error?.localizedDescription, preferredStyle: .alert);
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
                self.present(ac, animated: true, completion: nil);
            }
            else
            {
                let emailKey:String = self.emailToKey();
 
                var root = FIRDatabase.database().reference(fromURL: "https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(emailKey)")
               // print(" and the uid is : https://chatapp-f774b.firebaseio.com/mychatapp/allusers/\(user!.uid)");
                root.setValue(["userID": user!.uid ,
                               "userDisplayName":self.displayUITextField.text! ,
                               "friendRequests":"",
                               "conversations":"",
                               "friends":""
                    ]);

                
                
                /*
                node = root.child(self.emailUITextField.text!);
                node.setValue([
                    "userDisplayName":self.displayUITextField.text
                    ]);
                node.setValue("friendRequests");
                node.setValue("messages");
 */
            }
            
            // ...
        }
        
        
                
        
        
    }
    func emailToKey() -> String{
        return emailUITextField.text!.replacingOccurrences(of: ".", with: ",");
    }

}
