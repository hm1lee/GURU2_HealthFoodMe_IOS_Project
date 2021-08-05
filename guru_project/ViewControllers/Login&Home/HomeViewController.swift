//
//  HomeViewController.swift
//  CustomLoginDemo
//
//  Created by Christopher Ching on 2019-07-22.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import UIKit
import FirebaseDatabase


class HomeViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ptLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getDatafromDB()
    }
    
    func getDatafromDB() {
        // username
        self.ref.child("users/test/usersInformation/username").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                DispatchQueue.main.async {
                    self.nameLabel.text = "\(snapshot.value!)"
                }
            }else {
                print("No data available")
            }
        }
        
        self.ref.child("users/test/usersInformation/ages").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                DispatchQueue.main.async {
                    self.ageLabel.text = "\(snapshot.value!)"
                }
            }else {
                print("No data available")
            }
        }
        
        self.ref.child("users/test/usersInformation/excercise").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                DispatchQueue.main.async {
                    self.ptLabel.text = "\(snapshot.value!)"
                }
            }else {
                print("No data available")
            }
        }
        
        self.ref.child("users/test/usersInformation/food type").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                DispatchQueue.main.async {
                    self.foodLabel.text = "\(snapshot.value!)"
                }
            }else {
                print("No data available")
            }
        }
    }


    @IBAction func pressedFood(_ sender: UIButton) {
        
        let foodVC = self.storyboard?.instantiateViewController(identifier: "foodVC") as? FoodViewController
        foodVC?.modalPresentationStyle = .fullScreen
        foodVC?.modalTransitionStyle = .crossDissolve
        self.present(foodVC!, animated: true, completion: nil)
        
    }
    
    @IBAction func pressedPT(_ sender: UIButton) {
        
        let ptVC = self.storyboard?.instantiateViewController(identifier: "ptVC") as? PTViewController
        ptVC?.modalPresentationStyle = .fullScreen
        ptVC?.modalTransitionStyle = .crossDissolve
        self.present(ptVC!, animated: true, completion: nil)
        
    }

}
