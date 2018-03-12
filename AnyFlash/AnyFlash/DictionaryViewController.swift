//
//  DictionaryViewController.swift
//  AnyFlash
//
//  Created by Isaac Chen on 3/11/18.
//  Copyright © 2018 Jerry Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DictionaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var table: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meanings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meaningCell", for: indexPath)
        
        cell.textLabel?.text = meanings[indexPath.row]
        tableView.tableFooterView = UIView()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.meaningToUse = meanings[indexPath.row]
    }
    
    
    var front = ""
    var category = ""
    var uid = ""
    var meanings: [String] = []
    var meaningToUse = ""
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 100
        table.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
        
        // TODO: replace with your own app id and app key
        let appId = "54f32088"
        let appKey = "b6b14e9a6009ef52eed0d6eb9aa7169b"
        let language = "en"
        let word = self.front
        let word_id = word.lowercased().trimmingCharacters(in: .whitespaces) //word id is case sensitive and lowercase is required
        let url = URL(string: "https://od-api.oxforddictionaries.com:443/api/v1/entries/\(language)/\(word_id)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(appId, forHTTPHeaderField: "app_id")
        request.addValue(appKey, forHTTPHeaderField: "app_key")
        
        let session = URLSession.shared
        _ = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response,
                let data = data,
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                //print(response)
                //print(jsonData)
                let usableJsonData = jsonData as! NSDictionary
                let results = usableJsonData.object(forKey: "results") as! NSArray
                let inResults = results[0] as! NSDictionary
                let lexicalEntries = inResults.object(forKey: "lexicalEntries") as! NSArray
                let inLexicalEntries = lexicalEntries[0] as! NSDictionary
                let entries = inLexicalEntries.object(forKey: "entries") as! NSArray
                let inEntries = entries[0] as! NSDictionary
                let senses = inEntries.object(forKey: "senses") as! NSArray
                
                
                senses.forEach({ (elem) in
                    let inSenses = elem as! NSDictionary // there should be multiple here
                    let definitions = inSenses.object(forKey: "definitions") as! NSArray
                    let def = definitions[0] as! String
                    
                    print(def)
                    self.meanings.append(def)
                })
                
                print("outside reload")
                DispatchQueue.main.async {
                    print("inside reload")
                    self.table.reloadData()
                }

                
                
            } else {
                print("failed to get data")
            }
        }).resume()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        if meaningToUse.isEmpty{
            Util.showAlert(self, "please select a definition")
        } else {
            self.ref.child("users").child(self.uid).child(self.category).child(self.front).child("back").setValue(self.meaningToUse)
            self.ref.child("users").child(self.uid).child(self.category).child(self.front).child("learned").setValue(false)
            performSegue(withIdentifier: "addDictrionary", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dictToFront" {
            let destination = segue.destination as! AddFrontViewController
            destination.uid = self.uid
            destination.category = self.category
        } else if segue.identifier == "addDictrionary" {
            let destination = segue.destination as! CardsListViewController
            destination.uid = self.uid
            destination.category = self.category
        }
    }


}
