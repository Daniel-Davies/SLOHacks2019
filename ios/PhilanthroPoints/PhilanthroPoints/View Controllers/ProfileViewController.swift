//
//  ProfileViewController.swift
//  PhilanthroPoints
//
//  Created by Chase Carnaroli on 2/2/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var qrCode: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var profile = Profile(name: "name", points: 0)
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// CollectionView Setup
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Configure Layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*2)/2
        let posterSize = CGSize(width: width, height: width*1.5)
        layout.itemSize = posterSize
        
        getProfile()
    }
    
    func getProfile() {
        // Set Up Request
        let url = URL(string: "http://129.65.102.125:5000/getUser/asdf@gmail.com")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                //let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // Get the array of movies
                let profileJSON = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.profile = Profile(name: profileJSON["name"] as! String, points: profileJSON["points"] as! Int)
                
                print(self.profile)
                self.getEventsByUser(userEmail: "")//self.profile["email"] as! String)
                // Reload table view data
                self.collectionView.reloadData()
            }
        }
        task.resume()
    }
    
    func getEventsByUser(userEmail: String) {
        // Set Up Request
        let url = URL(string: "http://129.65.102.125:5000/getevents/asdf@gmail.com")!// + userEmail)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                //let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    
                // Get the array of movies
                let eventsJSON = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                print(eventsJSON)
                for eventJSON in eventsJSON {
                    let event = Event(
                        name: eventJSON["name"] as? String ?? "",
                        charity: eventJSON["charity"] as? String ?? "",
                        date: eventJSON["date"] as? String ?? "",
                        photoUrl: eventJSON["pictureUrl"] as! String
                    )
                    self.events.append(event)
                }
                print(self.events)
                
    
                // Reload table view data
                self.collectionView.reloadData()
            }
        }
        task.resume()
    }
    
    /*
     // MARK: - CollectionView Functions
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventCollectionViewCell
        
        // Get Photo
        // photo = photos[indexPath.row]
        print("loaded")
        // Get Event
        let event = self.events[indexPath.row]
        
        //cell.image.image = photo
        cell.eventName.text = event.name
        cell.date.text = event.date
        cell.charity.text = event.charity
        
        // Get Event Picture
        //let baseUrl = "https://pbs.twimg.com/media/"
        //let picUrl = event["pictureUrl"] as! String
        let picUrl = URL(string: event.photoUrl)
        
        // Set Movie Poster
        cell.image.af_setImage(withURL: picUrl!)
        
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
