//
//  QuizFrontViewController.swift
//  AnyFlash
//
//  Created by Isaac Chen on 3/11/18.
//  Copyright © 2018 Jerry Li. All rights reserved.
//

import UIKit

class QuizFrontViewController: UIViewController {
    
    var uid = ""
    var category = ""
    var flashCardData: NSDictionary!
    var currentIndex = 0
    
    @IBOutlet weak var cardFrontLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let keys = flashCardData.allKeys
        if self.currentIndex == keys.count {
            self.currentIndex = 0
            self.cardFrontLabel.text = keys[currentIndex] as? String
        } else {
            self.cardFrontLabel.text = keys[currentIndex] as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextCardPressed(_ sender: Any) {
        let keys = flashCardData.allKeys
        self.currentIndex+=1
        if self.currentIndex == keys.count {
            self.currentIndex = 0
            self.cardFrontLabel.text = keys[currentIndex] as? String
        } else {
            self.cardFrontLabel.text = keys[currentIndex] as? String
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromQuizFront" {
            let destination = segue.destination as! CardsListViewController
            destination.uid = self.uid
            destination.category = self.category
        } else if segue.identifier == "flip" {
            let destination = segue.destination as! QuizBackViewController
            destination.uid = self.uid
            destination.category = self.category
            destination.currentIndex = self.currentIndex
            destination.flashCardData = self.flashCardData
        }
    }


}
