//
//  AddBackViewController.swift
//  AnyFlash
//
//  Created by Isaac Chen on 3/10/18.
//  Copyright © 2018 Jerry Li. All rights reserved.
//

import UIKit

class AddBackViewController: UIViewController {
    
    var uid = ""
    var front = ""
    var category = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToFront" {
            let destination = segue.destination as! AddFrontViewController
            destination.uid = self.uid
            destination.category = self.category
        }
    }

}
