//
//  CardsListViewController.swift
//  AnyFlash
//
//  Created by Isaac Chen on 3/10/18.
//  Copyright © 2018 Jerry Li. All rights reserved.
//

import UIKit

class CardsListViewController: UIViewController {
    
    var uid = ""
    var category = ""

    @IBOutlet weak var courseNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(self.uid)
        print(self.category)
        
        courseNameLabel.text = self.category
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "cardListToCourses") {
            let destination = segue.destination as! CoursesViewController
            destination.uid = self.uid
        }
    }
}
