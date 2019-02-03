//
//  EventDetailViewController.swift
//  PhilanthroPoints
//
//  Created by Chase Carnaroli on 2/3/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var charityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    var event = Event(
        name: "",
        charity: "",
        date: "",
        desc: "",
        photoUrl: ""
    )
    var registered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventNameLabel.text = event.name
        charityLabel.text = event.charity
        dateLabel.text = event.date
        descriptionLabel.text = event.desc
        
        if registered {
            signUpButton.isEnabled = false
        }
    }
    
    @IBAction func signedUp(_ sender: Any) {
        // Send post request
        sendSignUpPost(eventName: event.name, charity: event.charity)
        
        // Disable button
        signUpButton.titleLabel?.text = "Registered!"
        signUpButton.isEnabled = false
        
    }
    
    func sendSignUpPost(eventName: String, charity: String) {
        // prepare json data
        let json: [String: Any] = ["email": "chase19@ymail.com",
                                   "Organization": charity,
                                   "EventName": eventName]
        print(json)
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
  
        // create post request
        let url = URL(string: "http://207.62.168.42:5000/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        
        task.resume()
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
