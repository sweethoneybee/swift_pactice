//
//  ViewController.swift
//  SubmitValue
//
//  Created by 정성훈 on 2020/12/27.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // 이메일 주소를 입력받는 텍스트 필드
    @IBOutlet var email: UITextField!
    
    // 자동 갱신 여부를 설정하는 스위치
    @IBOutlet var isUpdate: UISwitch!
   
    //갱신 주기를 설정하는 스테퍼
    @IBOutlet var interval: UIStepper!
    
    
    // 자동 갱신 여부를 표시하는 레이블
    @IBOutlet var isUpdateText: UILabel!
    
    
    // 갱신 주기를 텍스트로 표시하는 레이블
    @IBOutlet var intervalText: UILabel!
    
    // 자동 갱신 여부가 바뀔 때마다 호출되는 메소드
    @IBAction func onSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            self.isUpdateText.text = "갱신함"
        } else {
            self.isUpdateText.text = "갱신하지 않음"
        }
    }
    
    // 갱신 주기가 바뀔 때마다 호출되는 메소드
    @IBAction func onStepper(_ sender: UIStepper) {
        let value = Int(sender.value)
        
        self.intervalText.text = "\(value)분마다"
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        // VC2의 인스턴스 생성
        guard let rvc = self.storyboard?.instantiateViewController(withIdentifier: "RVC") as? ResultViewController else {
            return
        }
        
        NSLog("rvc 생성 완료 직후")
        
        // 값 전달
        rvc.paramEmail = self.email.text! // 이메일
        rvc.paramUpdate = self.isUpdate.isOn // 자동 갱신 여부
        rvc.paramInterval = self.interval.value // 갱신 주기
    
        // 화면 이동
        NSLog("화면 이동 직전")
        self.present(rvc, animated: true)
    }
}

