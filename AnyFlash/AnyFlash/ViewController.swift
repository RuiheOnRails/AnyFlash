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
    
    var handle: AuthStateDidChangeListenerHandle?
    var uid = ""
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
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                self.uid = (user?.uid)!
                self.performSeg()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
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
                    self.uid = (user?.uid)!
                    self.performSeg()
                }
            }
        }
    }
    
    
    func performSeg() {
        performSegue(withIdentifier: "signInDone", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signInDone" {
            let destination = segue.destination as! CoursesViewController
            destination.uid = self.uid
        }
    }
}

