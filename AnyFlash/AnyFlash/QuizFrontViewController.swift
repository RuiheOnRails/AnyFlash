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
    var isFlipped = false
    var keys : [Any] = []
    var values : [Any] = []
    @IBOutlet weak var numOutaNum: UILabel!
    
    @IBOutlet weak var cardFrontLabel: UILabel!
    
    override func viewDidLoad() {
        keys = flashCardData.allKeys
        values = flashCardData.allValues
        super.viewDidLoad()
        cardFrontLabel.text = keys[currentIndex] as? String
        numOutaNum.text = "\(self.currentIndex+1)/\(self.flashCardData.count-1)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnFlip(_ sender: Any) {
        var frontText = ""
        var backText = ""
        if isFlipped{
            isFlipped = false
            if self.currentIndex == keys.count-1 {
                self.currentIndex = 0
                frontText = (keys[currentIndex] as? String)!
            } else {
                frontText = (keys[currentIndex] as? String)!
            }

            if frontText != "cardPlaceHolderKey" {
                self.cardFrontLabel.text = keys[currentIndex] as? String
            } else {
                self.cardFrontLabel.text = keys.last as? String
            }
            numOutaNum.text = "\(self.currentIndex+1)/\(self.flashCardData.count-1)"

            UIView.transition(with: cardFrontLabel, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        } else {
            isFlipped = true
            if self.currentIndex == values.count-1 {
                self.currentIndex = 0
                backText = (values[currentIndex] as? String)!
            } else {
                backText = (values[currentIndex] as? String)!
            }

            if backText != "cardValue" {
                self.cardFrontLabel.text = values[currentIndex] as? String
            } else {
                self.cardFrontLabel.text = values.last as? String
            }
            numOutaNum.text = "\(self.currentIndex+1)/\(self.flashCardData.count-1)"

            UIView.transition(with: cardFrontLabel, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
    }
    
    
    
    @IBAction func nextCardPressed(_ sender: Any) {
        self.currentIndex+=1
        var text = ""
        isFlipped = false
        if self.currentIndex == keys.count-1 {
            self.currentIndex = 0
            text = (keys[currentIndex] as? String)!
        } else {
            text = (keys[currentIndex] as? String)!
        }

        if text != "cardPlaceHolderKey" {
            self.cardFrontLabel.text = keys[currentIndex] as? String
        } else {
            self.cardFrontLabel.text = keys.last as? String
        }
        numOutaNum.text = "\(self.currentIndex+1)/\(self.flashCardData.count-1)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromQuizFront" {
            let destination = segue.destination as! CardsListViewController
            destination.uid = self.uid
            destination.category = self.category
        }
    }


}
