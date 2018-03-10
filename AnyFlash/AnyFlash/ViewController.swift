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

class ViewController: UIViewController {
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        self.ref.child("test4").setValue(["thisComesFromApp": "valueHere!"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

