//
//  AddHabitViewController.swift
//  Habits
//
//  Created by 김가은 on 2021/07/24.
//

import UIKit
import FirebaseDatabase

protocol HabitDelegate {
    func habitModified(type:Bool)
}

class AddHabitViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var explainTextField: UITextField!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completeBtn: UIButton!
    
    @IBOutlet weak var alarmIconBtn: UIButton!
    @IBOutlet weak var bedIconBtn: UIButton!
    @IBOutlet weak var bookIconBtn: UIButton!
    @IBOutlet weak var computerIconBtn: UIButton!
    @IBOutlet weak var cookingIconBtn: UIButton!
    @IBOutlet weak var dietIconBtn: UIButton!
    @IBOutlet weak var facialCareIconBtn: UIButton!
    @IBOutlet weak var keyboardIconBtn: UIButton!
    @IBOutlet weak var medicineIconBtn: UIButton!
    @IBOutlet weak var moneyIconBtn: UIButton!
    @IBOutlet weak var pencilIconBtn: UIButton!
    @IBOutlet weak var runningIconBtn: UIButton!
    @IBOutlet weak var speakingIconBtn: UIButton!
    @IBOutlet weak var starIconBtn: UIButton!
    @IBOutlet weak var waterIconBtn: UIButton!
    
    var ref: DatabaseReference!
    var iconImageName = ""
    var countOfHabits = 0
    var selectedIconBtnCount = 0
    var selectedColor = ""
    var titleText = ""
    var explanationText = ""
    var modifyIndex = 0
    var index = 0
    
    let iconNames = ["alarm", "bed", "book", "computer", "cooking", "diet", "facialCare", "keyboard", "medicine", "money", "pencil", "running", "speaking", "star", "water"]
    let colors = ["systemPink", "systemGreen", "systemIndigo", "systemPurple", "systemYellow", "systemOrange"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDataFromDB()
    }
    
    @IBAction func pressCompleteButton(_ sender: Any) { // 완료 버튼 누르면 실행
        getDataFromDB()
        
        if (iconImageName == "") { // 아이콘을 선택하지 않은 경우에
            iconImageName = "star" // default icon은 star
        }
        
        if (titleTextField.text?.isEmpty != true && explainTextField.text?.isEmpty != true) { // 모든 텍스트 필드가 공백이 아닌 경우
            if (countOfHabits > 6) {
                if (countOfHabits % 6 == 0) {
                    countOfHabits = 6
                } else {
                    countOfHabits = countOfHabits % 6
                }
            }
            self.ref.child("users/Habit/Habit" + "\(self.countOfHabits)" + "/countOfHabits").setValue(["count": countOfHabits % 6])
            self.ref.child("users/Habit/Habit" + "\(self.countOfHabits)" + "/title").setValue(["habitTitle": titleTextField.text])
            self.ref.child("users/Habit/Habit" + "\(self.countOfHabits)" + "/explanation").setValue(["habitExplanation": explainTextField.text])
            self.ref.child("users/Habit/Habit" + "\(self.countOfHabits)" + "/iconImage").setValue(["iconName": iconImageName])
            self.ref.child("users/Habit/Habit" + "\(self.countOfHabits)" + "/progressBarColor").setValue(["colorName": selectedColor])
            
            self.navigationController?.popToRootViewController(animated: true)
        } else { // 텍스트 필드에 공백이 하나라도 존재하는 경우 알림 띄우기
            let alertVC = UIAlertController(title: "작성 불가능", message: "작성 완료를 하려면 공백이 있으면 안 됩니다!", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: false, completion: nil)
        }
    }
    
    func buttonClick(_ index: Int, _ sender: UIButton) { // 아이콘 버튼 클릭이 되면
        switch index { // 매개변수로 받아온 인덱스와 버튼에 따라서
        case 0 ... 14:
            if (selectedIconBtnCount == 0 && sender.isSelected == false) {
                sender.isSelected = true
                selectedIconBtnCount = 1
                iconImageName = iconNames[index]
                sender.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                sender.layer.cornerRadius = 5
                sender.layer.borderWidth = 3
                sender.layer.borderColor = UIColor.systemGreen.cgColor
            } else if (selectedIconBtnCount == 1 && sender.isSelected == true) {
                sender.isSelected = false
                selectedIconBtnCount = 0
                iconImageName = ""
                sender.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                sender.layer.borderColor = UIColor.clear.cgColor
            } else {
                let alertVC = UIAlertController(title: "중복 선택 불가", message: "아이콘은 하나만 선택할 수 있습니다! 다시 눌러 취소하고 다른 아이콘을 선택해주세요.", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: false, completion: nil)
            }
        default:
            print("error")
        }
    }
    
    @IBAction func clickAlarmBtn(_ sender: Any) {
        buttonClick(0, alarmIconBtn)
    }
    @IBAction func clickBedBtn(_ sender: Any) {
        buttonClick(1, bedIconBtn)
    }
    @IBAction func clickBookBtn(_ sender: Any) {
        buttonClick(2, bookIconBtn)
    }
    @IBAction func clickComputerBtn(_ sender: Any) {
        buttonClick(3, computerIconBtn)
    }
    @IBAction func clickCookingBtn(_ sender: Any) {
        buttonClick(4, cookingIconBtn)
    }
    @IBAction func clickDietBtn(_ sender: Any) {
        buttonClick(5, dietIconBtn)
    }
    @IBAction func clickFacialCareBtn(_ sender: Any) {
        buttonClick(6, facialCareIconBtn)
    }
    @IBAction func clickKeyboardBtn(_ sender: Any) {
        buttonClick(7, keyboardIconBtn)
    }
    @IBAction func clickMedicineBtn(_ sender: Any) {
        buttonClick(8, medicineIconBtn)
    }
    @IBAction func clickMoneyBtn(_ sender: Any) {
        buttonClick(9, moneyIconBtn)
    }
    @IBAction func clickPencilBtn(_ sender: Any) {
        buttonClick(10, pencilIconBtn)
    }
    @IBAction func clickRunningBtn(_ sender: Any) {
        buttonClick(11, runningIconBtn)
    }
    @IBAction func clickSpeakingBtn(_ sender: Any) {
        buttonClick(12, speakingIconBtn)
    }
    @IBAction func clickStarBtn(_ sender: Any) {
        buttonClick(13, starIconBtn)
    }
    @IBAction func clickWaterBtn(_ sender: Any) {
        buttonClick(14, waterIconBtn)
    }
    
    func selectColor(_ index: Int) {
        switch index {
        case 0 ... 5:
            self.selectedColor = colors[index]
            colorLabel.text = "color : " + colors[index]
        default:
            print ("nothing")
        }
    }
    
    func setCountOfHabits (_ countOfHabits: Int) {
        self.countOfHabits = countOfHabits
    }
    
    @IBAction func selectRed(_ sender: Any) {
        selectColor(0)
    }
    @IBAction func selectGreen(_ sender: Any) {
        selectColor(1)
    }
    @IBAction func selectIndigo(_ sender: Any) {
        selectColor(2)
    }
    @IBAction func selectPurple(_ sender: Any) {
        selectColor(3)
    }
    @IBAction func selectYellow(_ sender: Any) {
        selectColor(4)
    }
    @IBAction func selectOrange(_ sender: Any) {
        selectColor(5)
    }
    
    func getDataFromDB() {
        index = self.countOfHabits
        if (index % 6 == 0) {
            index = 6
        } else {
            index = index % 6
        }
        // DB에 저장된 습관 제목 불러오기
        self.ref.child("users/Habit/Habit" + "\(index)" + "/title/habitTitle").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("snapshot exists, Got data \(snapshot.value!)")
                self.titleText = "\(snapshot.value!)"
            } else {
                print("No data available")
            }
        }
        
        // DB에 저장된 습관에 대한 간략한 설명 불러오기
        self.ref.child("users/Habit/Habit" + "\(index)" + "/explanation/habitExplanation").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("snapshot exists, Got data \(snapshot.value!)")
                self.explanationText = "\(snapshot.value!)"
            } else {
                print("No data available")
            }
        }
        
        // DB에 저장된 icon 이름 불러오기
        self.ref.child("users/Habit/Habit" + "\(index)" + "/iconImage/iconName").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("snapshot exists, Got data \(snapshot.value!)")
                self.iconImageName = "\(snapshot.value!)"
            } else {
                print("No data available")
            }
        }
        
        // DB에 저장된 progress bar 색상 불러오기
        self.ref.child("users/Habit/Habit" + "\(index)" + "/progressBarColor/colorName").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("snapshot exists, Got data \(snapshot.value!)")
                self.selectedColor = "\(snapshot.value!)"
            } else {
                print("No data available")
            }
        }
        
        self.ref.child("users/Habit/Habit" + "\(index)" + "/countOfHabits/count").getData {
            (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            } else if snapshot.exists() {
                print("snapshot exists, Got data \(snapshot.value!)")
                self.countOfHabits = Int("\(snapshot.value!)")!
            } else {
                print("No data available")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

