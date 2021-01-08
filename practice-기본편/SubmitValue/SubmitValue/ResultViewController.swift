import UIKit

class ResultViewController: UIViewController {
    
    // 화면에 값을 표시하는 데 사용될 레이블
    @IBOutlet var resultEmail: UILabel! // 이메일
    @IBOutlet var resultUpdate: UILabel! // 자동갱신 여부
    @IBOutlet var resultInterval: UILabel! // 갱신주기
    
    var paramEmail: String = ""
    var paramUpdate: Bool = false
    var paramInterval: Double = 0
    
    override func viewDidLoad() {
        self.resultEmail.text = paramEmail
        self.resultUpdate.text = self.paramUpdate == true ? "자동갱신" : "자동갱신안함"
        self.resultInterval.text = "\(Int(paramInterval))분마다 갱신"
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}
