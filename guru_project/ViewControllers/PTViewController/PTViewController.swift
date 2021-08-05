//
//  PTViewController.swift
//  guru_project
//
//  Created by 양성혜 on 2021/08/04.
//

import UIKit
import FirebaseDatabase


class PTViewController:UIViewController {
    
    var all:[String] = ["파워 클린","푸르프레스"]
    var leg:[String] = ["백 스쿼트","프론트 스쿼트","레그 프레스","레그 익스텐션","레그 컬","런지"]
    var chest:[String] = ["벤치 프레스","덤벨 플라이","케이블 크로스오버","풀 오버","딥스","펙 덱 플라이","시티드 체스트 프레스"]
    var shoulder:[String] = ["숄더 프레스","프론트 레이즈","레터럴 레이즈","벤트 오버 래터럴 레이즈"]
    var back:[String] = ["렛 풀다운","벤트 오버 로우","시티드 로우","굿모닝 엑서싸이즈","쉬러그"]
    var stomach:[String] = ["크런치","트위스트 크런치","싯 업","레그 레이즈"]
    var arm:[String] = ["바벨 컬","프리쳐 컬","라잉 트라이셉스 익스텐션","트라이셉스 푸쉬다운","덤벨 킥백","리스트 컬","리버스 리스트 컬"]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var dateString = ""
    var num = Int.random(in: 1...50)
    var namePT = ""

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        print("show tableview")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        dateString = dateFormatter.string(from: Date())
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .orange
        refreshControl.addTarget(self, action: #selector(fetchData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
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
    
    @objc func fetchData(_ sender:Any){
        tableView.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goTimer" {
            if let timerViewController = segue.destination as? TimerViewController {
                timerViewController.number = self.num
                timerViewController.day = self.dateString
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

extension PTViewController:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.all.count
        case 1:
            return self.leg.count
        case 2:
            return self.chest.count
        case 3:
            return self.shoulder.count
        case 4:
            return self.back.count
        case 5:
            return self.stomach.count
        case 6:
            return self.arm.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ptCell", for: indexPath) as! ptCell
        var name = ""
        
        switch indexPath.section {
        case 0:
            name = self.all[indexPath.row]
        case 1:
            name = self.leg[indexPath.row]
        case 2:
            name = self.chest[indexPath.row]
        case 3:
            name = self.shoulder[indexPath.row]
        case 4:
            name = self.back[indexPath.row]
        case 5:
            name = self.stomach[indexPath.row]
        case 6:
            name = self.arm[indexPath.row]
        default:
            name = "none"
        }
            
        cell.ptLabel?.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "[전신 운동]"
        case 1:
            return "[다리 운동]"
        case 2:
            return "[가슴 운동]"
        case 3:
            return "[어깨 운동]"
        case 4:
            return "[등 운동]"
        case 5:
            return "[복부 운동]"
        case 6:
            return "[팔 운동]"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        
        switch indexPath.section {
        case 0:
            namePT = self.all[indexPath.row]
        case 1:
            namePT = self.leg[indexPath.row]
        case 2:
           namePT = self.chest[indexPath.row]
        case 3:
            namePT = self.shoulder[indexPath.row]
        case 4:
            namePT = self.back[indexPath.row]
        case 5:
            namePT = self.stomach[indexPath.row]
        case 6:
            namePT = self.arm[indexPath.row]
        default:
            namePT = "none"
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
       
        self.ref.child("users/user_pt/\(dateString)/\(num)").setValue(["PTName": namePT])
        
        performSegue(withIdentifier: "goTimer", sender: self)
        
        }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.width / 8
    }
}
