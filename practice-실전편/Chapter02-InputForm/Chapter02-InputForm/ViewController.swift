//
//  ViewController.swift
//  Chapter02-InputForm
//
//  Created by 정성훈 on 2021/01/08.
//

import UIKit

class ViewController: UIViewController {
    
    var paramEmail: UITextField? // 이메일 입력 필드
    var paramUpdate: UISwitch? // 스위치 객체
    var paramInterval: UIStepper? // 스테퍼
    var txtUpdate: UILabel? // 스위치 컨트롤의 값을 표현할 레이블
    var txtInterval: UILabel? // 스테퍼 컨트롤의 값을 표현할 레이블
    
    override func viewDidLoad() {
        // 1. 내비게이션 바 타이틀을 입력한다.
        self.navigationItem.title = "설정"
        
        // 2. 이메일 레이블 생성하고 영영과 기본 문구 설정
        let lblEmail = UILabel()
        lblEmail.frame = CGRect(x: 30, y: 100, width: 100, height: 30)
        lblEmail.text = "이메일"
        
        // 3. 레이블의 폰트를 설정
//        lblEmail.font = UIFont.systemFont(ofSize: 14)
        let customFont = UIFont(name: "BMDoHyeon-OTF", size: 14)
        lblEmail.font = customFont
        
        // 4. 레이블을 루트 뷰에 추가
        self.view.addSubview(lblEmail)
        
        // 자동갱신 레이블 생성하고 루트 뷰에 추가
        let lblUpdate = UILabel()
        lblUpdate.frame = CGRect(x: 30, y: 150, width: 100, height: 30)
        lblUpdate.text = "자동갱신"
        lblUpdate.font = UIFont.systemFont(ofSize: 14)
        
        self.view.addSubview(lblUpdate)
        
        // 갱신주기 레이블 생성하고 루트 뷰에 추가
        let lblInterval = UILabel()
        lblInterval.frame = CGRect(x: 30, y: 200, width: 100, height: 30)
        lblInterval.text = "갱신주기"
        lblInterval.font = UIFont.systemFont(ofSize: 14)
        
        self.view.addSubview(lblInterval)
        
        // 이메일 입력을 위한 텍스트 필드를 추가한다
        self.paramEmail = UITextField()
        self.paramEmail?.frame = CGRect(x: 120, y: 100, width: 220, height: 30)
        self.paramEmail?.font = UIFont.systemFont(ofSize: 13)
        self.paramEmail?.borderStyle = .roundedRect
        self.paramEmail?.autocapitalizationType = .none
        
        if let paramEmailTextField = self.paramEmail {
            self.view.addSubview(paramEmailTextField)
        }
        
        // 스위치 객체를 생성한다
        self.paramUpdate = UISwitch()
        self.paramUpdate?.frame = CGRect(x: 120, y: 150, width: 50, height: 30)
        
        // 스위치가 on 되어있는 상태를 기본값으로 설정한다
        self.paramUpdate?.setOn(true, animated: true)
        
        if let paramUpdateSwitch = self.paramUpdate {
            self.view.addSubview(paramUpdateSwitch)
            
            // 액션 메소드 연결
            paramUpdateSwitch.addTarget(self, action: #selector(presentUpdateValue(_:)), for: .valueChanged)
        }
        
        // 갱신주기를 위한 스테퍼 추가
        self.paramInterval = UIStepper()
        self.paramInterval?.frame = CGRect(x: 120, y: 200, width: 50, height: 30)
        self.paramInterval?.minimumValue = 0 // 스테퍼가 가질 수 있는 최소값
        self.paramInterval?.maximumValue = 100 // 스테퍼가 가질 수 있는 최대값
        self.paramInterval?.stepValue = 1 // 스테퍼의 값 변경 단위
        self.paramInterval?.value = 0 // 초기값 설정
        
        if let paramIntervalStepper = self.paramInterval {
            self.view.addSubview(paramIntervalStepper)
            
            // 액션 메소드 연결
            paramIntervalStepper.addTarget(self, action: #selector(presentIntervalValue(_:)), for: .valueChanged)
        }
        
        // 스위치 객체의 값을 표현할 레이블을 추가한다
        self.txtUpdate = UILabel()
        
        self.txtUpdate?.frame = CGRect(x: 250, y: 150, width: 100, height: 30)
        self.txtUpdate?.font = UIFont.systemFont(ofSize: 12)
        self.txtUpdate?.textColor = UIColor.red // 텍스트의 색상
        self.txtUpdate?.text = "갱신함" // 갱신함 or 갱신하지 않음
        
        if let txtUpdateLabel = self.txtUpdate {
            self.view.addSubview(txtUpdateLabel)
        }
        
        // 스테퍼의 값을 표현할 레이블을 추가한다
        self.txtInterval = UILabel()
        if let txtIntervalLabel = self.txtInterval {
            txtIntervalLabel.frame = CGRect(x: 250, y: 200, width: 100, height: 30)
            txtIntervalLabel.font = UIFont.systemFont(ofSize: 12)
            txtIntervalLabel.textColor = UIColor.red
            txtIntervalLabel.text = "0분마다"
            
            self.view.addSubview(txtIntervalLabel)
        }
        
        // 전송 버튼을 내비게이션 아이템에 추가하고, submit 메소드에 연결한다
        let submitBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(submit(_:)))
        self.navigationItem.rightBarButtonItem = submitBtn
        
        // 커스텀 폰트의 Post Script Name 찾기
//        for family in UIFont.familyNames {
//            print("\(family)")
//
//            for names in UIFont.fontNames(forFamilyName: family) {
//                print("== \(names)")
//            }
//        }
    }
    
    // 스위치와 상호반응할 액션 메소드
    @objc func presentUpdateValue(_ sender: UISwitch) {
        self.txtUpdate?.text = (sender.isOn == true ? "갱신함" : "갱신하지 않음")
    }
    
    // 스테퍼와 상호반응할 액션 메소드
    @objc func presentIntervalValue(_ sender: UIStepper) {
        if let intervalValue = self.paramInterval?.value {
            self.txtInterval?.text = "\( Int(intervalValue) )분마다"
        }
    }
    
    // 전송 버튼과 상호반응할 액션 메소드
    @objc func submit(_ sender: Any) {
        let rvc = ReadViewController()
        rvc.pEmail = self.paramEmail?.text
        rvc.pUpdate = self.paramUpdate?.isOn
        rvc.pInterval = self.paramInterval?.value
        
        self.navigationController?.pushViewController(rvc, animated: true)
    }

}

