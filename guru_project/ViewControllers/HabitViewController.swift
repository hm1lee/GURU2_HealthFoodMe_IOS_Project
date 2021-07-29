//
//  ViewController.swift
//  Habits
//
//  Created by 김가은 on 2021/07/24.
//

import UIKit
import FirebaseDatabase

class HabitViewController: UIViewController {
    
    @IBOutlet weak var addHabitButton: UIButton! // 습관 추가 (plus) 버튼
    
    var ref: DatabaseReference!
    var countOfHabits = 0 // 습관 개수
    // iphone 12 기준
    var x_constraints = [60, 240] // x 좌표 모음
    var y_constraints = [200, 390, 580] // y 좌표 모음
    // 전역 변수
    let now = NSDate()
    let dateFormatter = DateFormatter()
    var titleText = ""
    var explanationText = ""
    var iconImageName = ""
    var selectedColor = ""
    var modifyIndex = 0
    var progressDegree = 0.0
    var modifyStatus = false
    var todayDate = ""
    let colors = ["systemPink", "systemGreen", "systemIndigo", "systemPurple", "systemYellow", "systemOrange"]
    var progress = CircleProgress(frame: CGRect(x: 0, y: 0, width: 80, height: 80)) // progress bar (기본 위치로 설정)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getDataFromDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDataFromDB()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // progress의 path가 유지되어 뜨도록 설정
        progress.setPath(self.progressDegree)
        getDataFromDB()
        progress.clickDBRead()
        switch countOfHabits { // 습관 개수에 따라 함수 실행
        case 0:
            break
        case 1...:
            if (countOfHabits % 6 == 0) {
                countOfHabits = 6
            } else {
                countOfHabits = countOfHabits % 6
            }
            addLabels(countOfHabits)
        default:
            print("error")
            
        }
    }
    
    func addLabels(_ countOfHabits: Int) {
        getDataFromDB() // DB로부터 데이터 읽어오기
        
        switch countOfHabits {
        // 몇 번째 추가한 습관이냐에 따라 위치 선정
        case 1:
            progress = CircleProgress(frame: CGRect(x: x_constraints[0], y: y_constraints[0], width: 80, height: 80))
        case 2:
            progress = CircleProgress(frame: CGRect(x: x_constraints[1], y: y_constraints[0], width: 80, height: 80))
        case 3:
            progress = CircleProgress(frame: CGRect(x: x_constraints[0], y: y_constraints[1], width: 80, height: 80))
        case 4:
            progress = CircleProgress(frame: CGRect(x: x_constraints[1], y: y_constraints[1], width: 80, height: 80))
        case 5:
            progress = CircleProgress(frame: CGRect(x: x_constraints[0], y: y_constraints[2], width: 80, height: 80))
        case 6:
            progress = CircleProgress(frame: CGRect(x: x_constraints[1], y: y_constraints[2], width: 80, height: 80))
        default:
            return
        }
        self.view.addSubview(progress) // 프로그레스 바 추가
        
        progress.setIndex(self.countOfHabits) // progress의 개수에 따라 index 설정
        // subView에 label과 button 추가
        progress.addSubview(progress.titleLabel)
        progress.addSubview(progress.explanationLabel)
        progress.addSubview(progress.iconView)
        // 각각 constaraint 지정
        progress.iconView.translatesAutoresizingMaskIntoConstraints = false
        progress.iconView.topAnchor.constraint(equalTo: progress.topAnchor, constant: 0).isActive = true
        progress.iconView.bottomAnchor.constraint(equalTo: progress.bottomAnchor, constant: 0).isActive = true
        progress.iconView.leadingAnchor.constraint(equalTo: progress.leadingAnchor, constant: 0).isActive = true
        progress.iconView.trailingAnchor.constraint(equalTo: progress.trailingAnchor, constant: 0).isActive = true
        progress.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        progress.titleLabel.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: 25).isActive = true
        progress.titleLabel.leadingAnchor.constraint(equalTo: progress.leadingAnchor, constant:  0).isActive = true
        progress.titleLabel.trailingAnchor.constraint(equalTo: progress.trailingAnchor, constant: 0).isActive = true
        progress.explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        progress.explanationLabel.topAnchor.constraint(equalTo: progress.titleLabel.bottomAnchor, constant: 3).isActive = true
        progress.explanationLabel.leadingAnchor.constraint(equalTo: progress.leadingAnchor, constant: 0).isActive = true
        progress.explanationLabel.trailingAnchor.constraint(equalTo: progress.trailingAnchor, constant: 0).isActive = true
        
        // 각각에 필요한 설정
        progress.titleLabel.textAlignment = .center
        progress.titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        progress.explanationLabel.textAlignment = .center
        progress.explanationLabel.textColor = UIColor.lightGray
        progress.explanationLabel.numberOfLines = 2
        progress.explanationLabel.font = UIFont.systemFont(ofSize: 13)
        
        // DB에서 받아와 저장된 값들로 text 또는 이미지 지정
        progress.titleLabel.text = self.titleText
        progress.explanationLabel.text = self.explanationText
        progress.iconView.setImage(UIImage(named: iconImageName), for: .normal)
        progress.setPath(self.progressDegree) // progress의 path 설정
        
        switch selectedColor { // progress의 stroke color 설정
        case colors[0] :
            progress.setStrokeColor(UIColor.systemPink.cgColor)
        case colors[1]:
            progress.setStrokeColor(UIColor.systemGreen.cgColor)
        case colors[2]:
            progress.setStrokeColor(UIColor.systemIndigo.cgColor)
        case colors[3]:
            progress.setStrokeColor(UIColor.systemPurple.cgColor)
        case colors[4]:
            progress.setStrokeColor(UIColor.systemYellow.cgColor)
        case colors[5]:
            progress.setStrokeColor(UIColor.systemOrange.cgColor)
        default:
            progress.setStrokeColor(UIColor.systemTeal.cgColor)
        }
    }
    
    func setModifyStatus(_ modifyStatus: Bool) { // 수정 여부에 대한 상태 설정
        self.modifyStatus = modifyStatus
    }
    
    func setCountOfHabits(_ countOfHabits: Int) {
        self.countOfHabits = countOfHabits
    }
    
    @IBAction func addHabit(_ sender: Any) {
        // 습관을 추가하는 이벤트가 일어났을 때 실행되는 메소드 (스토리 보드 이동)
        countOfHabits = countOfHabits + 1 // 습관 개수 하나 증가
        if (countOfHabits > 6) {
            if (countOfHabits % 6 == 0) {
                countOfHabits = 6
            } else {
                    countOfHabits = countOfHabits % 6
            }
        }
        let addHabitVC: AddHabitViewController = storyboard?.instantiateViewController(withIdentifier: "addHabit") as! AddHabitViewController
        addHabitVC.setCountOfHabits(countOfHabits)

        self.navigationController?.pushViewController(addHabitVC, animated: true) // 화면 이동
    }
    
    func alert(_ title: String, _ message: String) { // 오류 알림 띄우기
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) {
            (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertVC.addAction(okAction)
        self.present(alertVC, animated: false, completion: nil)
    }
    
    func setModifyIndex(_ modifyIndex: Int) {
        self.modifyIndex = progress.index
    }
    
    func getDataFromDB() {
        // DB에서 데이터 읽어오기
        if (countOfHabits % 6 == 0) {
            countOfHabits = 6
        } else {
            countOfHabits = countOfHabits % 6
        }
        self.ref.child("users/Habit/Habit" + "\(self.countOfHabits)" + "/progressDegree/degree").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                self.progressDegree = Double("\(snapshot.value!)")!
            } else {
                print("No data available")
            }
        }
        
        self.ref.child("users/Habit/Habit" + "\(self.countOfHabits)" + "/countOfHabits/count").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                self.modifyIndex = Int("\(snapshot.value!)")!
            } else {
                print("No data available")
            }
        }
        
        // DB에 저장된 습관 제목 불러오기
        self.ref.child("users/Habit/Habit" + "\(self.countOfHabits)" + "/title/habitTitle").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                self.titleText = "\(snapshot.value!)"
            } else {
                print("No data available")
            }
        }
        
        // DB에 저장된 습관에 대한 간략한 설명 불러오기
        self.ref.child("users/Habit/Habit" + "\(self.countOfHabits)" + "/explanation/habitExplanation").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                self.explanationText = "\(snapshot.value!)"
            } else {
                print("No data available")
            }
        }
        
        // DB에 저장된 icon 이름 불러오기
        self.ref.child("users/Habit/Habit" + "\(self.countOfHabits)" + "/iconImage/iconName").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                self.iconImageName = "\(snapshot.value!)"
            } else {
                print("No data available")
            }
        }
        
        // DB에 저장된 progress bar 색상 불러오기
        self.ref.child("users/Habit/Habit" + "\(self.countOfHabits)" + "/progressBarColor/colorName").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                self.selectedColor = "\(snapshot.value!)"
            } else {
                print("No data available")
            }
        }
        // DB에 저장된 날짜 불러오기
        self.ref.child("users/Habit/Habit" + "\(self.countOfHabits)" + "/updateDate/date").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                self.todayDate = "\(snapshot.value!)"
            } else {
                print("No data available")
            }
        }
    }
}

