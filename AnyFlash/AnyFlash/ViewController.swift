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
    
    
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var signInBTN: UIButton!
    
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

    @IBAction func signInBTNClicked(_ sender: Any) {
        let sself = self
        if (emailBox.text?.isEmpty)! || (passwordBox.text?.isEmpty)! {
            Util.showAlert(self,"email and password should not be empty")
        } else {
            Auth.auth().signIn(withEmail: emailBox.text!, password: passwordBox.text!) { (user, error) in
                if user == nil {
                    Util.showAlert(sself,"email and password combination does not exist")
                } else {
                   performSegue(withIdentifier: "signInDone", sender: sself)
                }
            }
        }
    }
}

