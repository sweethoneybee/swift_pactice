//
//  SecondViewController.swift
//  WeakSelfTest
//
//  Created by 정성훈 on 2021/07/30.
//

import UIKit

class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTimerButton(_ sender: Any) {
        print("5초 타이머 시작!")
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] _ in
            print("5초 다 지났음!")
            if self != nil {
                print("VC는 메모리에 살아있다")
            } else {
                print("VC는 메모리에서 해제되었다")
            }
        }
    }
}
