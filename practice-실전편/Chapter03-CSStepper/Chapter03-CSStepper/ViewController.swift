//
//  ViewController.swift
//  Chapter03-CSStepper
//
//  Created by 정성훈 on 2021/01/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        // CSStepper 객체 정의
        let stepper = CSStepper()
        stepper.frame = CGRect(x: 30, y: 100, width: 130, height: 30)
        self.view.addSubview(stepper)
    }


}

