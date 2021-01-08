import UIKit

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        NSLog("SecondViewController의 viewDidLoad 호출. 이후 3초간 대기")
        sleep(3)
        
        NSLog("viewDidLoad 호출 완료")
    }
}
