//
//  PrizeCell.swift
//  PhilanthroPoints
//
//  Created by Mugetron Blue on 2/2/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit

class PrizeCell: UITableViewCell {

    @IBOutlet weak var PrizeImage: UIImageView!
    @IBOutlet weak var RewardAmount: UILabel!
    @IBOutlet weak var Points: UILabel!
    var view = UIViewController()
    var prize = Prize(name:"none",points:0,redeem:"i", product:"o")
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func RedeemTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "Do you wish to redeem your points?", message: "25 points will be deducted from your total for 5$ off Tacqueria Santa Cruz.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: sendEmail()))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        view.present(alert, animated: true, completion:nil)
    }
    
    func sendEmail() {
        // Set Up Request
        let url = URL(string: "http://129.65.102.125:5000/redeem")!
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
                
                self.prize = Prize(
                    name: profileJSON["product"] as! String,
                    points: profileJSON["points"] as! Int,
                    redeem: profileJSON["product"] as! String,
                    product: profileJSON["product"] as! String)
                
                print(self.prize)
            }
        }
        task.resume()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
