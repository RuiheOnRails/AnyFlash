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

class AddCatViewController: UIViewController {
    
    var uid = ""
    var ref: DatabaseReference!
    var flashCardData: NSDictionary!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        ref.child("users").child(self.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.flashCardData = (snapshot.value as? NSDictionary)!
        }) { (error) in
            print(error.localizedDescription)
        }
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
            self.ref.child("users").child(self.uid).child(textField.text!).setValue(["cardPlaceHolderKey":"cardValue"])
        }
        performSegue(withIdentifier: "addedCategory", sender: self)
    }
    

}
