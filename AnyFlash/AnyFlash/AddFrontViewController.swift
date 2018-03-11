//
//  AddFrontViewController.swift
//  AnyFlash
//
//  Created by Isaac Chen on 3/10/18.
//  Copyright © 2018 Jerry Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddFrontViewController: UIViewController {
    
    var uid = ""
    var front = ""
    var category = ""
    @IBOutlet weak var testFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cotinuePressed(_ sender: Any) {
        if (testFiled.text?.isEmpty)! {
            Util.showAlert(self, "please enter a front for your card")
        } else {
            self.front = testFiled.text!
            performSegue(withIdentifier: "continue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addFrontToCards" {
            let destination = segue.destination as! CardsListViewController
            destination.uid = self.uid
            destination.category = self.category
        } else if segue.identifier == "continue" {
            let destination = segue.destination as! AddBackViewController
            destination.uid = self.uid
            destination.front = self.front
            destination.category = self.category
        }
    }
    
    

}
