//
//  AddCatViewController.swift
//  AnyFlash
//
//  Created by Isaac Chen on 3/10/18.
//  Copyright © 2018 Jerry Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddCatViewController: UIViewController, UITextFieldDelegate {
    
    var uid = ""
    var ref: DatabaseReference!
    var flashCardData: NSDictionary!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        ref = Database.database().reference()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! CoursesViewController
        destination.uid = self.uid
    }
    
    @IBAction func addPressed(_ sender: Any) {
        if (textField.text?.isEmpty)! {
            Util.showAlert(self, "category cannot have empty name")
        } else {
           let catKey = self.ref.child("users").child(self.uid).childByAutoId().key
            self.ref.child("users").child(self.uid).child(catKey).setValue(["catName":textField.text!])
        }
        performSegue(withIdentifier: "addedCategory", sender: self)
    }
    

}
