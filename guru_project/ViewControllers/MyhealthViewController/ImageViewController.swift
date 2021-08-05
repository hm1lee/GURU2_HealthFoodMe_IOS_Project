//
//  ViewController.swift
//  FireStorageBasic
//
//  Created by 김가은 on 2021/07/19.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Photos
import AVKit

class ImageViewController: UIViewController {
    let storage = Storage.storage()
    var storageRef:StorageReference!
    var ref: DatabaseReference!
    var imagePicker:UIImagePickerController!
    var file_name:String!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        storageRef = storage.reference()
        ref = Database.database().reference()
    }
    
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
    
    
    @IBAction func uploadImage(_ sender: UIButton) {
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
 
    @IBAction func btnCamera(_ sender: UIButton) {
        print("camera pressed")
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            imagePicker  = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        case .notDetermined:
            print("결정안됨")
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                print(granted)
            }
        default:
            print("실패")
        }
    }
    
    
    
    
}


extension ImageViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
