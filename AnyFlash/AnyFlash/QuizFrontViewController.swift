//
//  QuizFrontViewController.swift
//  AnyFlash
//
//  Created by Isaac Chen on 3/11/18.
//  Copyright © 2018 Jerry Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class QuizFrontViewController: UIViewController {
    
    var uid = ""
    var category = ""
    var flashCardData: NSDictionary!
    var currentIndex = 0
    var isFlipped = false
    var keys : [String] = []
    var values : [String] = []
    var ref: DatabaseReference!
    @IBOutlet weak var numOutaNum: UILabel!
    
    @IBOutlet weak var cardFrontLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        ref.child("users").child(self.uid).child(category).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.flashCardData = (snapshot.value as? NSDictionary)!
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // these handle front back
        //======================================================
        //keys = flashCardData.allKeys as! [String]
        var tempKeys = flashCardData.allKeys as! [String]
        
        keys = []
        
        tempKeys.forEach { (key) in
            let valueData = flashCardData.object(forKey: key) as! NSDictionary
            if !(valueData.object(forKey: "learned") as! Bool){
                self.keys.append(key)
            }
        }
        
        
        //values = flashCardData.allValues as! [String]
        let valuesData = flashCardData.allValues as! [NSDictionary]
        
        valuesData.forEach { (dict) in
            if !(dict.object(forKey: "learned") as! Bool){
                values.append(dict.object(forKey: "back") as! String)
            }
        }
        
        // ================================================

        
        cardFrontLabel.text = keys[currentIndex]
        
        if cardFrontLabel.text != "cardPlaceHolderKey" {
            self.cardFrontLabel.text = keys[currentIndex]
        } else {
            self.cardFrontLabel.text = keys.last
        }
        
        numOutaNum.text = "\(self.currentIndex+1)/\(self.keys.count-1)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func randomClicked(_ sender: Any) {
        currentIndex = 0
        self.keys = shuffle(self.keys)
        self.values = []
        self.keys.forEach { (elem) in
            let valuesData = flashCardData.object(forKey: elem) as! NSDictionary
            values.append(valuesData.object(forKey: "back") as! String)
        }
        
        var frontText = ""
        
        isFlipped = false
        if self.currentIndex == keys.count-1 {
            self.currentIndex = 0
            frontText = (keys[currentIndex] as String)
        } else {
            frontText = (keys[currentIndex] as String)
        }
        
        if frontText != "cardPlaceHolderKey" {
            self.cardFrontLabel.text = keys[currentIndex] as String
        } else {
            self.cardFrontLabel.text = keys.last
        }
        numOutaNum.text = "\(self.currentIndex+1)/\(self.keys.count-1)"
        
        UIView.transition(with: cardFrontLabel, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    
    
    @IBAction func inOrderPressed(_ sender: Any) {
        currentIndex = 0
        isFlipped = false
        
        
//        keys = flashCardData.allKeys as! [String]
//        //values = flashCardData.allValues as! [String]
//        let valuesData = flashCardData.allValues as! [NSDictionary]
//        values = []
//        valuesData.forEach { (dict) in
//            values.append(dict.object(forKey: "back") as! String)
//        }
        
        keys = []
        values = []
        
        // these handle front back
        //======================================================
        //keys = flashCardData.allKeys as! [String]
        var tempKeys = flashCardData.allKeys as! [String]
        
        keys = []
        
        tempKeys.forEach { (key) in
            let valueData = flashCardData.object(forKey: key) as! NSDictionary
            if !(valueData.object(forKey: "learned") as! Bool){
                self.keys.append(key)
            }
        }
        
        
        //values = flashCardData.allValues as! [String]
        let valuesData = flashCardData.allValues as! [NSDictionary]
        
        valuesData.forEach { (dict) in
            if !(dict.object(forKey: "learned") as! Bool){
                values.append(dict.object(forKey: "back") as! String)
            }
        }
        
        // ================================================
        
        
        
        cardFrontLabel.text = keys[currentIndex] as String
        
        if cardFrontLabel.text != "cardPlaceHolderKey" {
            self.cardFrontLabel.text = keys[currentIndex] as String
        } else {
            self.cardFrontLabel.text = keys.last
        }
        
        numOutaNum.text = "\(self.currentIndex+1)/\(self.keys.count-1)"
    }
    
    
    
    
    //this shuffles an array through math
    func shuffle(_ listToShuffle: [String]) -> [String] {
        var counter = listToShuffle.count
        var array:[String] = []
        listToShuffle.forEach { (elem) in
            array.append(elem)
        }
        
        while counter > 0 {
            let idxRandom = floor(drand48() * Double(counter))
            counter-=1
            
            let temp = array[counter]
            array[counter] = array[Int(idxRandom)]
            array[Int(idxRandom)] = temp
        }
        
        return array
    }
    
    
    @IBAction func btnFlip(_ sender: Any) {
        var frontText = ""
        var backText = ""
        if isFlipped{
            isFlipped = false
            if self.currentIndex == keys.count-1 {
                self.currentIndex = 0
                frontText = (keys[currentIndex])
            } else {
                frontText = (keys[currentIndex])
            }

            if frontText != "cardPlaceHolderKey" {
                self.cardFrontLabel.text = keys[currentIndex]
            } else {
                self.cardFrontLabel.text = keys.last
            }
            numOutaNum.text = "\(self.currentIndex+1)/\(self.keys.count-1)"

            UIView.transition(with: cardFrontLabel, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        } else {
            isFlipped = true
            if self.currentIndex == values.count-1 {
                self.currentIndex = 0
                backText = (values[currentIndex])
            } else {
                backText = (values[currentIndex])
            }

            if backText != "cardValue" {
                self.cardFrontLabel.text = values[currentIndex]
            } else {
                self.cardFrontLabel.text = values.last
            }
            numOutaNum.text = "\(self.currentIndex+1)/\(self.keys.count-1)"

            UIView.transition(with: cardFrontLabel, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
    }
    
    
    
    
    @IBAction func nextCardPressed(_ sender: Any) {
        self.currentIndex+=1
        var text = ""
        isFlipped = false
        if self.currentIndex == keys.count-1 {
            self.currentIndex = 0
            text = (keys[currentIndex])
        } else {
            text = (keys[currentIndex])
        }

        if text != "cardPlaceHolderKey" {
            self.cardFrontLabel.text = keys[currentIndex]
        } else {
            self.cardFrontLabel.text = keys.last
        }
        numOutaNum.text = "\(self.currentIndex+1)/\(self.keys.count-1)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromQuizFront" {
            let destination = segue.destination as! CardsListViewController
            destination.uid = self.uid
            destination.category = self.category
        }
    }


}
