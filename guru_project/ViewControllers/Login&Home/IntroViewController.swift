//
//  introViewController.swift
//  guru_project
//
//  Created by 양성혜 on 2021/07/23.
//

import UIKit
import SwiftyGif

class IntroViewController:UIViewController {
    @IBOutlet weak var intro_image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let gif = try UIImage(gifName: "intro.gif")
            self.intro_image.setImage(gif,loopCount: 5)
            self.intro_image.delegate = self
        } catch {
            NSLog("재생불가")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in self.goMainView()
        }
    }
}

extension IntroViewController:SwiftyGifDelegate{
    func gifDidStop(sender: UIImageView) {
        print("gifDidStop")
    }
    
    func goMainView(){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginView"){
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
}

