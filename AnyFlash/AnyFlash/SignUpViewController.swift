//
//  SignUpViewController.swift
//  AnyFlash
//
//  Created by Jerry Li on 3/9/18.
//  Copyright © 2018 Jerry Li. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleSignUp(_ sender: UIButton) {
        
        if((emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!){
            Util.showAlert(self,"Please enter a email and password")
        }else if (!Util.isValidEmail(emailTextField.text!)){
            Util.showAlert(self,"Invalid Email")
            emailTextField.becomeFirstResponder()
        }else if(confirmTextField.text! != passwordTextField.text!){
            Util.showAlert(self,"passwords mismatch")
            passwordTextField.becomeFirstResponder()
        }else if((passwordTextField.text?.count) ?? 0 < 6){
            Util.showAlert(self,"password must be 6 characters or more")
        }else{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){
                (user, error) in
                if((error) != nil){
                    NSLog(error.debugDescription)
                }else{
                    print(user?.uid ?? "no user id")
                }
            }
            performSegue(withIdentifier: "signUpDone", sender: self)
        }
    }
}
