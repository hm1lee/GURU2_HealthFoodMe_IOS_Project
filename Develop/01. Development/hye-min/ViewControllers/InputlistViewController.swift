//
//  InputlistViewController.swift
//  guru_project
//
//  Created by 양성혜 on 2021/07/24.
//

import UIKit
import FirebaseDatabase

class InputlistViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var agesPickerView: UITextField!
    @IBOutlet weak var heightPickerView: UITextField!
    @IBOutlet weak var weightPickerView: UITextField!
    @IBOutlet weak var excercisePickerView: UITextField!
    @IBOutlet weak var diseaseTextField: UITextField!
    @IBOutlet weak var medicineTextField: UITextField!
    @IBOutlet weak var foodPickerView: UITextField!
    @IBOutlet weak var smokingPickerView: UITextField!
    @IBOutlet weak var drinkingPickerView: UITextField!
    
    let agePV = UIPickerView()
        let heightPV = UIPickerView()
        let weightPV = UIPickerView()
        let excercisePV = UIPickerView()
        let foodPV = UIPickerView()
        let smokingPV = UIPickerView()
        let drinkingPV = UIPickerView()
        
        var ref: DatabaseReference!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            ref = Database.database().reference()
            
            // Do any additional setup after loading the view.
            agesPickerView.tintColor = .clear
            heightPickerView.tintColor = .clear
            weightPickerView.tintColor = .clear
            excercisePV.tintColor = .clear
            foodPV.tintColor = .clear
            smokingPV.tintColor = .clear
            drinkingPV.tintColor = .clear
            
            agePV.delegate = self
            agesPickerView.inputView = agePV
            heightPV.delegate = self
            heightPickerView.inputView = heightPV
            weightPV.delegate = self
            weightPickerView.inputView = weightPV
            excercisePV.delegate = self
            excercisePickerView.inputView = excercisePV
            foodPV.delegate = self
            foodPickerView.inputView = foodPV
            smokingPV.delegate = self
            smokingPickerView.inputView = smokingPV
            drinkingPV.delegate = self
            drinkingPickerView.inputView = drinkingPV
            
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.action))
            toolBar.setItems([button], animated: true)
            toolBar.isUserInteractionEnabled = true
            
            agesPickerView.inputAccessoryView = toolBar
            heightPickerView.inputAccessoryView = toolBar
            weightPickerView.inputAccessoryView = toolBar
            excercisePickerView.inputAccessoryView = toolBar
            foodPickerView.inputAccessoryView = toolBar
            smokingPickerView.inputAccessoryView = toolBar
            drinkingPickerView.inputAccessoryView = toolBar
        }
        
        let ages = ["10대", "20대", "30대", "40대", "50대", "60대", "60대 이상"]
        let heights = Array<Int>(145...199) // 키 배열
        let weights = Array<Int>(30...120) // 몸무게 배열
        let excercisesAndDrinking = ["안 함", "주 1회", "주 2회", "주 3회", "주 4회", "주 5회", "주 6회", "주 7회"]
        let foods = ["채식", "육식", "혼합식"]
        let smoking = ["흡연", "비흡연"]
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            var res = 0
            switch pickerView {
            case agePV:
                res = ages.count
            case heightPV:
                res = heights.count
                break
            case weightPV:
                res = weights.count
                break
            case excercisePV, drinkingPV:
                res = excercisesAndDrinking.count
                break
            case foodPV:
                res = foods.count
                break
            case smokingPV:
                res = smoking.count
                break
            default:
                print("선택 안 된 항목 존재")
                break
            }
            return res
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            var res = ""
            switch pickerView {
            case agePV:
                res = ages[row]
                break
            case heightPV:
                res = "\(heights[row])"
                break
            case weightPV:
                res = "\(weights[row])"
                break
            case excercisePV, drinkingPV:
                res = excercisesAndDrinking[row]
                break
            case foodPV:
                res = foods[row]
                break
            case smokingPV:
                res = smoking[row]
                break
            default:
                print("선택 안 된 항목 존재")
                break
            }
            return res
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch pickerView {
            case agePV:
                agesPickerView.text = ages[row]
                break
            case heightPV:
                heightPickerView.text = "\(heights[row])"
                break
            case weightPV:
                weightPickerView.text = "\(weights[row])"
                break
            case excercisePV:
                excercisePickerView.text = excercisesAndDrinking[row]
                break
            case foodPV:
                foodPickerView.text = foods[row]
                break
            case smokingPV:
                smokingPickerView.text = smoking[row]
                break
            case drinkingPV:
                drinkingPickerView.text = excercisesAndDrinking[row]
                break
            default:
                print("선택 안 된 항목 존재")
                break
            }
        }
        
        @objc func action() {
            self.view.endEditing(true)
        }
        
        @IBAction func clickOK(_ sender: Any) {
            print("clicked")
            if ((nameTextField.text?.isEmpty) ?? true) {
                print("name Error")
                let alertVC = UIAlertController(title: "이름을 입력하세요", message: "이름은 필수 입력 항목입니다!", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: false, completion: nil)
            } else if (nameTextField.text != "" &&
                        agesPickerView.text != "" &&
                        heightPickerView.text != "" &&
                        weightPickerView.text != "" &&
                        excercisePickerView.text != "" &&
                        foodPickerView.text != "" &&
                        smokingPickerView.text != "" &&
                        drinkingPickerView.text != "") {
                self.ref.child("usersInformation/" + nameTextField.text!).setValue(["username": nameTextField.text, "ages": agesPickerView.text, "height": heightPickerView.text, "weight": weightPickerView.text, "excercise": excercisePickerView.text, "disease": diseaseTextField.text, "medicine": medicineTextField.text, "food type": foodPickerView.text, "smoking": smokingPickerView.text, "drinking": drinkingPickerView.text])
            } else {
                let alertVC = UIAlertController(title: "공백 존재", message: "입력되지 않은 부분이 존재합니다!", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: false, completion: nil)
            }
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
}

