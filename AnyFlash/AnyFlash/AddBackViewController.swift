//
//  AddBackViewController.swift
//  AnyFlash
//
//  Created by Isaac Chen on 3/10/18.
//  Copyright © 2018 Jerry Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddBackViewController: UIViewController {
    
    var uid = ""
    var front = ""
    var catKey = ""
    var back = ""
    var ref: DatabaseReference!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        print(self.front)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addBackPressed(_ sender: Any) {
        if (textField.text?.isEmpty)! {
            Util.showAlert(self, "back side of a card cannot be empty")
        } else {
            let wordID = self.ref.child("users").child(self.uid)
                .child(self.catKey).child("words").childByAutoId().key
            
            self.ref.child("users").child(self.uid)
                .child(self.catKey).child("words").child(wordID).child("front").setValue(self.front)
            self.ref.child("users").child(self.uid)
                .child(self.catKey).child("words").child(wordID).child("back").setValue(textField.text)
            self.ref.child("users").child(self.uid)
                .child(self.catKey).child("words").child(wordID).child("learned").setValue(false)
            performSegue(withIdentifier: "cardAdded", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToFront" {
            let destination = segue.destination as! AddFrontViewController
            destination.uid = self.uid
            destination.catKey = self.catKey
        } else if segue.identifier == "cardAdded" {
            let destination = segue.destination as! CardsListViewController
            destination.uid = self.uid
            destination.catKey = self.catKey
        }
    }

}
