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
        
        // Disable button
        signUpButton.titleLabel?.text = "Registered!"
        signUpButton.isEnabled = false
        
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
