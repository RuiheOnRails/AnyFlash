//
//  ViewController.swift
//  AnyFlash
//
//  Created by Jerry Li on 2/24/18.
//  Copyright © 2018 Jerry Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
//        self.ref.child("test4").setValue(["thisComesFromApp": "valueHere!"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var emailBox: UITextField!
    
    @IBOutlet weak var signInBTN: UIButton!
    
    @IBAction func signInBTNClicked(_ sender: Any) {
        if (emailBox.text?.isEmpty)! || (passwordBox.text?.isEmpty)! {
            showAlert(msg: "email and password should not be empty")
        } else {
            Auth.auth().signIn(withEmail: emailBox.text!, password: passwordBox.text!) { (user, error) in
                if user == nil {
                    self.showAlert(msg: "email and password combination does not exist")
                } else {
                    self.performSeg()
                }
            }
        }
    }
    
    func showAlert(msg:String) {
        let alert = UIAlertController(title: "Warning!", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func performSeg() {
        performSegue(withIdentifier: "signInDone", sender: self)
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    


}

