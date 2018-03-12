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
    @IBOutlet weak var numOutaNum: UILabel!
    
    @IBOutlet weak var cardBackLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let values = flashCardData.allValues
        var text = ""
        if self.currentIndex == values.count-1 {
            self.currentIndex = 0
            text = (values[currentIndex] as? String)!
        } else {
            text = (values[currentIndex] as? String)!
        }
        
        if text != "cardValue" {
            self.cardBackLabel.text = values[currentIndex] as? String
        } else {
            self.cardBackLabel.text = values.last as? String
        }
        
        numOutaNum.text = "\(self.currentIndex+1)/\(self.flashCardData.count-1)"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromQuizBack" {
            let destination = segue.destination as! CardsListViewController
            destination.catKey = self.category
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
