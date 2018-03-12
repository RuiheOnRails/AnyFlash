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

class FlashCardViewController: UIViewController {
    
    var uid = ""
    var catKey = ""
    var flashCardData: NSDictionary!
    var currentIndex = 0
    var isFlipped = false
    var frontBackData:[NSDictionary] = []
    var ref: DatabaseReference!
    @IBOutlet weak var numOutaNum: UILabel!
    
    @IBOutlet weak var cardFrontLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        ref.child("users").child(self.uid).child(catKey).child("words").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            var tempData = (snapshot.value as? NSDictionary)!
            let frontBackArray = tempData.allValues as! [NSDictionary]
            frontBackArray.forEach({ (dict) in
                let bool = dict.object(forKey: "learned") as! Bool
                if !bool {
                    self.frontBackData.append(dict)
                }
            })
            self.cardFrontLabel.text = self.frontBackData[self.currentIndex].object(forKey: "front") as! String
            self.numOutaNum.text = "\(self.currentIndex+1)/\(self.frontBackData.count)"
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func randomClicked(_ sender: Any) {
        currentIndex = 0
        self.frontBackData = shuffle(self.frontBackData)
        isFlipped = false
        cardFrontLabel.text = self.frontBackData[currentIndex].object(forKey: "front") as! String
        numOutaNum.text = "\(self.currentIndex+1)/\(self.frontBackData.count)"
    }

    @IBAction func inOrderPressed(_ sender: Any) {
        currentIndex = 0
        isFlipped = false
        frontBackData = []
        
        ref.child("users").child(self.uid).child(catKey).child("words").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            var tempData = (snapshot.value as? NSDictionary)!
            let frontBackArray = tempData.allValues as! [NSDictionary]
            frontBackArray.forEach({ (dict) in
                let bool = dict.object(forKey: "learned") as! Bool
                if !bool {
                    self.frontBackData.append(dict)
                }
            })
            self.cardFrontLabel.text = self.frontBackData[self.currentIndex].object(forKey: "front") as! String
            self.numOutaNum.text = "\(self.currentIndex+1)/\(self.frontBackData.count)"
        }) { (error) in
            print(error.localizedDescription)
        }

        
    }
    
    //this shuffles an array through math
    func shuffle(_ listToShuffle: [NSDictionary]) -> [NSDictionary] {
        var counter = listToShuffle.count
        var array:[NSDictionary] = []
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
        if isFlipped{
            isFlipped = false
            if self.currentIndex == frontBackData.count {
                self.currentIndex = 0
            }
            self.cardFrontLabel.text = (self.frontBackData[currentIndex].object(forKey: "front") as! String)
            numOutaNum.text = "\(self.currentIndex+1)/\(self.frontBackData.count)"
            UIView.transition(with: cardFrontLabel, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        } else {
            isFlipped = true
            if self.currentIndex == frontBackData.count {
                self.currentIndex = 0
            }
            self.cardFrontLabel.text = (self.frontBackData[currentIndex].object(forKey: "back") as! String)
            numOutaNum.text = "\(self.currentIndex+1)/\(self.frontBackData.count)"
            UIView.transition(with: cardFrontLabel, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
    }

    @IBAction func nextCardPressed(_ sender: Any) {
        self.currentIndex+=1
        isFlipped = false
        if self.currentIndex == frontBackData.count {
            self.currentIndex = 0
        }
        self.cardFrontLabel.text = (self.frontBackData[currentIndex].object(forKey: "front") as! String)
        numOutaNum.text = "\(self.currentIndex+1)/\(self.frontBackData.count)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromQuizFront" {
            let destination = segue.destination as! CardsListViewController
            destination.uid = self.uid
            destination.catKey = self.catKey
        }
    }
}
