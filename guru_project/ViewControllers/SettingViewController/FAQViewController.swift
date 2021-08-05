//
//  FAQViewController.swift
//  guru_project
//
//  Created by 양성혜 on 2021/08/04.
//

import UIKit

class FAQViewController:UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}
