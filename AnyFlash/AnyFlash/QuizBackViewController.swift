//
//  QuizBackViewController.swift
//  AnyFlash
//
//  Created by Isaac Chen on 3/11/18.
//  Copyright © 2018 Jerry Li. All rights reserved.
//

import UIKit

class QuizBackViewController: UIViewController {
    
    var category = ""
    var uid = ""
    var flashCardData: NSDictionary!
    var currentIndex = 0
    
    @IBOutlet weak var cardBackLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let values = flashCardData.allValues
        self.cardBackLabel.text = values[currentIndex] as? String

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromQuizBack" {
            let destination = segue.destination as! CardsListViewController
            destination.category = self.category
            destination.uid = self.uid
        } else if segue.identifier == "flipBack" {
            let destination = segue.destination as! QuizFrontViewController
            destination.category = self.category
            destination.uid = self.uid
            destination.currentIndex = self.currentIndex
            destination.flashCardData = self.flashCardData
        } else if segue.identifier == "backNextCard" {
            let destination = segue.destination as! QuizFrontViewController
            destination.category = self.category
            destination.uid = self.uid
            destination.currentIndex = self.currentIndex+1
            destination.flashCardData = self.flashCardData
        }
    }
 

}
