//
//  TimerViewController.swift
//  guru_project
//
//  Created by 양성혜 on 2021/08/03.
//

import UIKit
import FirebaseDatabase

class TimerViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var timer:Timer = Timer()
    var count:Int = 0
    var timerCounting:Bool = false
    var ifStart:Bool = false
    var allTime:Int = 0
    var ptNum = 0
    var day = ""
    var number = 0
    var name = ""
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
        
        startStopButton.setTitleColor(UIColor.green, for: .normal)
        swipeRecongnizer()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    func swipeRecongnizer() {
        let swipRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipRight)
    }
    
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
       getNameData()
    }
    
    func getNameData() {
    
        print("key =\(number)")
        print("day = \(day)")
        
        self.ref.child("users/user_pt/\(day)/\(number)/PTName").getData {
            (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("snapshot exists, Got data \(snapshot.value!)")
                DispatchQueue.main.async {
                    self.nameLabel.text = "\(snapshot.value!)"
                    print("\(snapshot.value!)")
                }
            } else {
                print("No data available")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goGraph" {
            if let graphViewController = segue.destination as? GraphViewController {
                
                graphViewController.day = self.day
                graphViewController.num = self.number
                graphViewController.time = self.allTime
            }
        }
    }
    
    @IBAction func resetTapped(_ sender: Any)
    {
        ifStart = false
        let alert = UIAlertController(title:"Reset Timer?", message: "정말 초기화 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { _ in
            // do noting
        }))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { _ in
            self.count = 0
            self.timer.invalidate()
            self.timerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            
            self.startStopButton.setTitle("START", for: .normal)
            self.startStopButton.setTitleColor(UIColor.black, for: .normal)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func startStopTapped(_ sender: Any)
    {
        if(timerCounting)
        {
            
            // stop을 눌렀을 때
            timerCounting = false
            timer.invalidate()
            startStopButton.setTitle("START", for: .normal)
            startStopButton.setTitleColor(UIColor.brown, for: .normal)
        }
        else
        {
            //start를 눌렀을 때
            timerCounting = true
            ifStart = true
            startStopButton.setTitle("STOP", for: .normal)
            startStopButton.setTitleColor(UIColor.red, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerCounter() -> Void
    {
        count = count + 1
        let time = secondsToHoursMIntesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerLabel.text = timeString
    }
    
    func secondsToHoursMIntesSeconds(seconds: Int) -> (Int, Int, Int)
    {
        allTime = seconds
        return ( (seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String
    {
        var timerString = ""
        timerString += String(format: "%02d", hours)
        timerString += " : "
        timerString += String(format: "%02d", minutes)
        timerString += " : "
        timerString += String(format: "%02d", seconds)
        return timerString
    }
    
    
    @IBAction func noteTapped(_ sender: Any) {
        
        if(timerCounting)
        {
            // 기록하기를 눌렀을 때
            timerCounting = false
            timer.invalidate()
            startStopButton.setTitle("START", for: .normal)
            startStopButton.setTitleColor(UIColor.green, for: .normal)
            print("stop")
            print(allTime)
            ref.child("users/user_pt/\(day)/\(number)").updateChildValues(["PTTime": allTime])
        }
        else
        {
            if ifStart {
                print(allTime)
                // 데이터 베이스에 넣기
                ref.child("users/user_pt/\(day)/\(number)").updateChildValues(["PTTime": allTime])
            } else {
            let alert = UIAlertController(title:"No time", message: "기록이 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { _ in
                // do noting
            }))
            self.present(alert, animated: true, completion: nil)
            }
        }
        
        performSegue(withIdentifier: "goGraph", sender: self)
    }
    
}
