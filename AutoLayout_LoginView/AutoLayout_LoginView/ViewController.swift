//
//  ViewController.swift
//  AutoLayout_LoginView
//
//  Created by 정성훈 on 2021/04/16.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustButtonDynamicType),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }

    @objc func adjustButtonDynamicType() {
        self.buttons.forEach { (button) in
            button.titleLabel?.adjustsFontForContentSizeCategory = true;
        }
    }
}

