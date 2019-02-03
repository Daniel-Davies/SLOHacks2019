//
//  PrizeViewController.swift
//  PhilanthroPoints
//
//  Created by Mugetron Blue on 2/2/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import UIKit

class PrizeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var prizes=[Prize(name: "Pizza Hut", points: 25, redeem: "2 for 1 pizza",product:"yuh",photo:UIImage(named: "pizzahut")!),
                Prize(name:"Dairy Queen", points:15, redeem:"Free Blizzard!",product:"yuh",photo:UIImage(named: "dq")!),
                Prize(name:"Coffee Bean", points:5, redeem:"Free  coffee!",product:"yuh",photo:UIImage(named: "coffeebean")!),
                Prize(name:"Peet's Coffee", points:5, redeem:"Free tea!",product:"yuh",photo:UIImage(named: "peets")!),
                Prize(name:"Wing Stop", points:20, redeem:"50% off",product:"yuh",photo:UIImage(named: "wingstop")!)]
    @IBOutlet weak var PrizeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PrizeTableView.dataSource=self
        self.PrizeTableView.delegate=self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prizes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PrizeTableView.dequeueReusableCell(withIdentifier: "PrizeCell", for: indexPath) as! PrizeCell
        cell.view=self
        
        let prize = prizes[indexPath.row]
        cell.prize = prize
        cell.Points.text=String(prize.points)
        cell.RewardAmount.text=prize.redeem
        cell.PrizeImage.image = prize.photo
        
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
