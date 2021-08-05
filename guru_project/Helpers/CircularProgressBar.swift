//
//  CircularProgressBar.swift
//  Habits
//
//  Created by 김가은 on 2021/07/24.
//

import UIKit
import FirebaseDatabase

// 터치하면 한 칸씩 채워지는 원형의 Progress Bar를 만들기 위한 class
class CircleProgress: UIView {
    // 전역변수
    var ref: DatabaseReference!
    let circle = CAShapeLayer()
    let progress = CAShapeLayer()
    var titleLabel = UILabel() // 습관 제목 label
    var explanationLabel = UILabel() // 습관에 대한 간략한 설명 label
    var iconView = UIButton(type: .custom)
    
    var progressDegree = 0.0
    var selectedColor = ""
    var index = 0
    var modifyStatus = false
    var date = Date()
    var todaydate = Date()
    var today = ""
    var todayString = ""
    var clicked: Bool = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Start()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Start()
    }
    
    func draw() {
        Start()
    }
    func Start() {
        todaydate = Calendar.current.date(byAdding: .day, value: 0, to: date)!
        ref = Database.database().reference()
        // DB 데이터 읽어오기
        getDataFromDB()
        let rect = self.bounds
        for layer in [progress, circle] {
            layer.strokeColor = UIColor.clear.cgColor
            layer.fillColor = nil
            self.layer.addSublayer(layer)
        }
        // 초기 값 설정
        titleLabel.text = ""
        explanationLabel.text = ""
        iconView.setImage(UIImage(named: "star"), for: .normal) // default 이미지는 star 이미지
        iconView.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//        iconView.addTarget(self, action: #selector(clickDBRead), for: .touchDown) // 눌렀을 때 DB 데이터 다시 읽어오기
        iconView.addTarget(self, action: #selector(clickEvent), for: .touchUpInside) // 눌렀다 떼면 click Event 함수 실행
        iconView.addTarget(self, action: #selector(remove), for: .touchDragOutside)
        // 프로그레스 두께 및 색상
        progress.lineWidth = 15
        progress.strokeColor = UIColor.systemTeal.cgColor
        // 패스 설정한 만큼 그려주기
        circle.path = UIBezierPath(ovalIn: rect).cgPath
        progress.strokeStart = 0
        
        if (todayString != today || today == "") {
            clicked = true
        }
        
        progress.path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: frame.size.width / 2, startAngle: CGFloat(0), endAngle: CGFloat(self.progressDegree * Double.pi), clockwise: true).cgPath
    }
    
    @objc func clickDBRead() { // DB 읽어오도록 하는 addTarget용 메소드
        getDataFromDB()
    }
    
    @objc func clickEvent() {
        // iconView를 클릭했을 때 실행되는 메소드
        date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        todayString = dateFormatter.string(from: self.todaydate)
        self.ref.child("users/Habit/Habit" + "\(self.index)" + "/updateDate").setValue(["date": self.todayString])
        if (clicked == true) {
            if (progressDegree + 0.05 < 2.0) {
                // 현재 progress degree에 0.05를 더했을 때 2.0(100%)이 넘어가는 경우에만 실행
                plusProgressDegree()
                // 결과를 DB에 업데이트
                self.ref.child("users/Habit/Habit" + "\(self.index)" + "/progressDegree").setValue(["degree": self.progressDegree])
            } else { // 그 외의 경우 iconView를 비활성화
                self.iconView.isEnabled = false
                self.removeFromSuperview()
            }
            clicked = false
        }
    }
    
    func setPath(_ progressDegree: Double) { // path의 endAngle을 progressDegree를 매개 변수로 받아 사용
        progress.path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: frame.size.width / 2, startAngle: CGFloat(0), endAngle: CGFloat(progressDegree * Double.pi), clockwise: true).cgPath
    }
    
    func plusProgressDegree() { // progressDegree를 0.1씩 늘여주는 메소드
        progressDegree = progressDegree + 0.1
        progress.path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: frame.size.width / 2, startAngle: CGFloat(0), endAngle: CGFloat(progressDegree * Double.pi), clockwise: true).cgPath
    }
    
    func setIndex(_ index: Int) { // 현재 습관의 index를 설정하는 메소드
        self.index = index
    }
    
    @objc func remove() {
        self.removeFromSuperview()
        self.ref.child("users/Habit/Habit" + "\(self.index)" + "/progressBarColor").setValue(["colorName": ""])
        self.ref.child("users/Habit/Habit" + "\(self.index)" + "/iconImage").setValue(["iconName": "star"])
        self.ref.child("users/Habit/Habit" + "\(self.index)" + "/countOfHabits").setValue(["count": self.index])
        self.ref.child("users/Habit/Habit" + "\(self.index)" + "/progressDegree").setValue(["degree": 0.0])
        self.clicked = true
    }
    
    func setStrokeColor(_ color: CGColor) { // stroke color 설정 메소드
        progress.strokeColor = color
    }
    
    func getDataFromDB() {
        // DB로부터 필요한 데이터를 받아오는 메소드
        self.ref.child("users/Habit/Habit" + "\(self.index)" + "/progressDegree/degree").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("snapshot exists, Got data \(snapshot.value!)")
                self.progressDegree = Double("\(snapshot.value!)")! // 받아와서 progressDegree 값으로 설정
            } else {
                print("No data available")
            }
        }
        self.ref.child("users/Habit/Habit" + "\(self.index)" + "/countOfHabits/count").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("snapshot exists, Got data \(snapshot.value!)")
                self.index = Int("\(snapshot.value!)")! // 받아와서 index 값으로 설정
            } else {
                print("No data available")
            }
        }
        self.ref.child("users/Habit/Habit" + "\(self.index)" + "/updateDate/date").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("snapshot exists, Got data \(snapshot.value!)")
                let temp = "\(snapshot.value!)" as String
                self.today = "\(temp)" // 받아와서 index 값으로 설정
            } else {
                print("No data available")
            }
        }
    }
}


