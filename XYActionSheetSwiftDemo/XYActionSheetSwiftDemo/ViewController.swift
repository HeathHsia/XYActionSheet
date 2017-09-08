//
//  ViewController.swift
//  XYActionSheetSwiftDemo
//
//  Created by FireHsia on 2017/9/8.
//  Copyright © 2017年 FireHsia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // MARK --- 弹出菜单
    @IBAction func XY_ActionSheet(_ sender: UIButton) {
        
        let titles = ["拍照", "从手机相册选择"]
        XYActionSheet.actionSheet().showActionSheetWithTitles(titles, { (index) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let subVC : SubViewController = storyboard.instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
            if titles.count > index {
                subVC.title = titles[index]
                subVC.view.backgroundColor = .white
                switch index {
                case 0:
                    
                    subVC.dismissButton.isHidden = true
                    self.navigationController?.pushViewController(subVC, animated: true)
                case 1:
                    
                    subVC.dismissButton.isHidden = false
                    self.present(subVC, animated: true, completion: nil)
                default : break
                }
            }else {
                // 取消操作
            }
        })
        
    }

}

