import UIKit

class FormViewController: UIViewController {
    
    @IBOutlet var email: UITextField!
    @IBOutlet var isUpdate: UISwitch!
    @IBOutlet var interval: UIStepper!
    
    @IBOutlet var isUpdateText: UILabel!
    @IBOutlet var intervalText: UILabel!
    
    // submit 버튼 클릭했을 때 호출되는 메소드
    @IBAction func onSubmit(_ sender: Any) {
        let preVc = self.presentingViewController
        guard let vc = preVc as? ViewController else {
            return
        }
        
        NSLog("값 전달")
        vc.paramEmail = email.text
        vc.paramUpdate = isUpdate.isOn
        vc.paramInterval = interval.value
        
//        vc.dismiss(animated: true)
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
