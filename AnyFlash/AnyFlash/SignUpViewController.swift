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
            showAlert("Please enter a email and password")
        }else if (!isValidEmail(emailTextField.text!)){
            showAlert("Invalid Email")
            emailTextField.becomeFirstResponder()
        }else if(confirmTextField.text! != passwordTextField.text!){
            showAlert("passwords mismatch")
            passwordTextField.becomeFirstResponder()
        }else if((passwordTextField.text?.count) ?? 0 < 6){
            showAlert("password must be 6 characters or more")
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

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func showAlert(_ msg: String){
        let alert = UIAlertController(title: "Sign Up Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
