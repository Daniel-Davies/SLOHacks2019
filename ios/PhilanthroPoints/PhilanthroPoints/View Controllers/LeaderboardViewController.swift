//
//  LeaderboardViewController.swift
//  PhilanthroPoints
//
//  Created by Chase Carnaroli on 2/2/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var profiles = [Profile]()

    @IBOutlet weak var leaderboardTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup TableView
        leaderboardTable.delegate = self
        leaderboardTable.dataSource = self
        
        // Get Leaderboard
        getLeaderboard()
    }
    
    func getLeaderboard() {
        // Set Up Request
        let url = URL(string: "http://129.65.102.125:5000/getusers")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                //let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // Get the array of movies
                let profileJSON = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                for p in profileJSON {
                    self.profiles.append(Profile(name: p["name"] as! String, points: p["points"] as! Int))
                }
                

                // Reload table view data
                self.leaderboardTable.reloadData()
            }
        }
        task.resume()
    }
    
    // Mark: Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell") as! LeaderboardTableViewCell
        
        // Get Profile
        let profile = profiles[indexPath.row]
        
        // Set Profile Information
        cell.nameLabel.text = profile.name
        cell.numberLabel.text = String(indexPath.row+1) + "."
        cell.pointsLabel.text = String(profile.points) + " points"
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
