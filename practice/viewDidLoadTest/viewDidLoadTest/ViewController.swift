//
//  ViewController.swift
//  viewDidLoadTest
//
//  Created by 정성훈 on 2020/12/27.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onPresent(_ sender: Any) {
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: "SVC") else {
            return
        }
        NSLog("svc 인스턴스화 완료. 3초 대기")
        sleep(3)
        
        NSLog("present 메소드 호출")
        self.present(svc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("세그웨이 실행. 3초간 대기")
        sleep(3)
    }

}

