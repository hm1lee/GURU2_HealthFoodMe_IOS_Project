//
//  MyhealthViewController.swift
//  guru_project
//
//  Created by 양성혜 on 2021/08/03.
//

import UIKit
import UIKit
import FirebaseStorage
import FirebaseDatabase
import Photos
import AVKit

class MyhealthViewController: UIViewController {
    let storage = Storage.storage()
 
    // 하단 3개 버튼
    @IBOutlet weak var profileEditBtn: UIButton!
    @IBOutlet weak var faqBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    
    
    var ref: DatabaseReference!
    var imagePicker:UIImagePickerController!
    var file_name:String!
    
    // 개인정보 데이터 받아올 Label 정의
    @IBOutlet weak var dataView: UILabel!
    @IBOutlet weak var weightView: UILabel!
    @IBOutlet weak var ageView: UILabel!
    @IBOutlet weak var heightView: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    // databaseReference
    var storageRef:StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageRef = storage.reference()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
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
        self.getDatafromDB()
    }
    
    func getDatafromDB() {
        // usernamㄷ
        
        
        self.ref.child("users/test/usersInformation/username").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                DispatchQueue.main.async {
                    self.dataView.text = "\(snapshot.value!)"
                }
            }else {
                print("No data available")
            }
        }
        
        self.ref.child("users/test/usersInformation/weight").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                DispatchQueue.main.async {
                    self.weightView.text = "\(snapshot.value!)"
                }
            }else {
                print("No data available")
            }
        }
        
        self.ref.child("users/test/usersInformation/height").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                DispatchQueue.main.async {
                    self.heightView.text = "\(snapshot.value!)"
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
                    self.ageView.text = "\(snapshot.value!)"
                }
            }else {
                print("No data available")
            }
        }
    }
    
    // 사진 업로드
 
    @IBAction func selectImage(_ sender: UIButton) {
        print("select")
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 취소버튼 추가
        let action_cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(action_cancel)
        
        // 갤러리 버튼 추가
        let action_gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            print("push gallery button")
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                print("접근 가능")
                self.showGallery()
            case .notDetermined:
                print("권한 요청한적 없음")
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
                    
                }
            default:
                let alertVC = UIAlertController(title: "권한 필요", message: "사진첩 접근 권한이 필요합니다. 설정 화면에서 설정해주세요.", preferredStyle: .alert)
                let action_settings = UIAlertAction(title: "Go Settings", style: .default) { (action) in
                    print("go settings")
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                }
                let action_cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alertVC.addAction(action_cancel)
                alertVC.addAction(action_settings)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        
        actionSheet.addAction(action_gallery)
        
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func uploadImage(_ sender: Any) {
        print("upload btn pressed")
        guard let image = imageView.image else {
            let alertVC = UIAlertController(title: "알림", message: "이미지를 선택하고 업로드 기능을 실행하세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        
        print("이미지 있음")
        if let data = image.pngData() {
            let imageRef = storageRef.child("images/\(file_name!).png")
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            let uploadTask = imageRef.putData(data, metadata: metadata) { (metadata, error) in
                
                if let error = error {
                    debugPrint(error)
                    return
                }
                guard let metadata = metadata else {
                    return
                }
              
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                      return
                    }
                    guard let key = self.ref.child("users/guru2/images").childByAutoId().key else { return }
                    
                    self.ref.child("users/guru2/images/\(key)").setValue(["image_url": downloadURL.absoluteString])
                    print(downloadURL, "upload complete")
                }
            }
        }
    }
    
}


extension MyhealthViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showGallery() {
        imagePicker  = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        
        if let url = info[.imageURL] as? URL {
            file_name = (url.lastPathComponent as NSString).deletingPathExtension
        }
        
        imageView.image = selectedImage
        
    }
}

