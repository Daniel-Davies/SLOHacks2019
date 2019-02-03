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
    var prize = Prize(name:"none",points:0,redeem:"i", product:"o", photo: UIImage(named: "pizzahut")!)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func RedeemTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "Do you wish to redeem your points?", message: "\(prize.points) points will be deducted from your total for \(prize.redeem)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in self.sendEmail(email: "chase19@ymail.com",points: self.prize.points, product: self.prize.redeem)}))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        view.present(alert, animated: true, completion:nil)
    }
    
    func sendEmail(email: String, points: Int, product: String) {
        let json: [String: Any] = ["email": email,
                                   "points": points,
                                   "product": product]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        print(json)
        // create post request
        let url = URL(string: "http://129.65.102.125:5000/redeem")!
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
