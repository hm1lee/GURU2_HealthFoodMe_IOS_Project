//
//  ViewController.swift
//  FireStorageBasic
//
//  Created by 김가은 on 2021/07/19.
//

import UIKit
import FirebaseDatabase
import AlamofireImage

class ImageListViewController:UIViewController {
    var ref: DatabaseReference!
    var refHandle:DatabaseHandle!
    var imageUrls = [String]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        
        refHandle = ref.child("users/guru2/images").observe(DataEventType.value, with: { (snapshot) in
            self.imageUrls = [String]()
            let imageDict = snapshot.value as? [String : AnyObject] ?? [:]
            //debugPrint(imageDict)
            for (key, value) in imageDict {
                self.imageUrls.append(value["image_url"]!! as! String)
            }
            self.collectionView.reloadData()
            print(self.imageUrls)
        })
    }
}


extension ImageListViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        let url = URL(string: imageUrls[indexPath.row])!
        cell.imageView.af.setImage(withURL: url)
        return cell
    }
}

extension ImageListViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width-20) / 3
        return CGSize(width: width, height: width)
    }
}
