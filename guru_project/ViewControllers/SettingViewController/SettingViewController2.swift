//
//  SettingViewController2.swift
//  guru_project
//
//  Created by 양성혜 on 2021/08/03.
//

import UIKit

class SettingViewController2: UIViewController{
    @IBAction func back(_ sender: Any) {
        NSLog("백버튼 누름")
        if let preVC = ViewController.self as? UIViewController{
            NSLog("get pre view controller")
            preVC.dismiss(animated: false, completion: nil)
        }
    }
}

