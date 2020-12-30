//
//  ViewController.swift
//  SubmitValue-Back
//
//  Created by 정성훈 on 2020/12/30.
//

import UIKit

class ViewController: UIViewController {

    // 값을 화면에 표시하기 위한 아울렛 변수들
    @IBOutlet var resultEmail: UILabel!
    @IBOutlet var resultUpdate: UILabel!
    @IBOutlet var resultInterval: UILabel!
    
    // 값을 직접 전달받을 프로퍼티들
    var paramEmail: String?
    var paramUpdate: Bool?
    var paramInterval: Double?
    
    // 화면이 표시될 때마다 실행되는 메소드. 처음 뷰가 등장할 때는 viewDidLoad() 호출 후 이 메소드가 호출된다.
    override func viewWillAppear(_ animated: Bool) {
        NSLog("viewWillApear 메소드 호출")
        if let email = paramEmail {
            resultEmail.text = email
        }
        
        if let update = paramUpdate {
            resultUpdate.text = update==true ? "자동갱신":"자동갱신안함"
        }
        
        if let interval = paramInterval {
            resultInterval.text = "\(Int(interval))분마다"
        }
    }
    
    // 프리젠테이션 스타일을 fullScreen으로 바꾸고 코드로 화면 전환을 함.
    @IBAction func onRegister(_ sender: Any) {
        guard let fvc = self.storyboard?.instantiateViewController(withIdentifier: "FormViewController") else {
            return
        }
        
        fvc.modalPresentationStyle = .fullScreen
        
        self.present(fvc, animated: true)
    }
    
    
    @IBAction func onManualSegue(_ sender: Any) {
        self.performSegue(withIdentifier: "ManualSegue", sender: self)
    }
}

