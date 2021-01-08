import UIKit

class FormViewController: UIViewController {
    
    @IBOutlet var email: UITextField!
    @IBOutlet var isUpdate: UISwitch!
    @IBOutlet var interval: UIStepper!
    
    @IBOutlet var isUpdateText: UILabel!
    @IBOutlet var intervalText: UILabel!
    
    // submit 버튼 클릭했을 때 호출되는 메소드
    @IBAction func onSubmit(_ sender: Any) {
        // UserDefaults 객체의 인스턴스 가져오기
        let ud = UserDefaults.standard
        
        // 값을 저장
        ud.set(self.email.text, forKey: "email")
        ud.set(self.isUpdate.isOn, forKey: "isUpdate")
        ud.set(self.interval.value, forKey: "interval")
        
        // 이전 화면 복귀
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func onSwitch(_ sender: UISwitch) {
        if(sender.isOn == true) {
            self.isUpdateText.text = "갱신함"
        } else {
            self.isUpdateText.text = "갱신하지 않음"
        }
    }
    
    @IBAction func onStepper(_ sender: UIStepper) {
        self.intervalText.text = "\(Int(sender.value))분마다"
    }
}
