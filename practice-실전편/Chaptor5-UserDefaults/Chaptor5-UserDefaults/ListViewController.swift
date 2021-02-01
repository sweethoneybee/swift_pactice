import UIKit

public enum GenderType: Int {
    case male = 0
    case female = 1
    
    static func getGenderValue(value: Int) -> GenderType? {
        switch value {
        case 0:
            return .male
        case 1:
            return .female
        default:
            return nil
        }
    }
    
    static func getGenderCode(value: GenderType) -> Int {
        return value.rawValue
    }
}

class ListViewController: UITableViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var married: UISwitch!
    
    @IBAction func edit(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
        
        alert.addTextField() {
            $0.text = self.name.text
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
            let value = alert.textFields?[0].text
            
            let plist = UserDefaults.standard
            plist.set(value, forKey: "name")
            
            self.name.text = value
        })
        
        self.present(alert, animated: true)
    }
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = GenderType.getGenderValue(value: sender.selectedSegmentIndex) // 0이면 남자, 1이면 여자
        let plist = UserDefaults.standard
        plist.set(value?.rawValue, forKey: "gender")
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn // true면 기혼, false면 미혼
        
        let plist = UserDefaults.standard
        plist.set(value, forKey: "married")
    }
    
    override func viewDidLoad() {
        let plist = UserDefaults.standard
        
        self.name.text = plist.string(forKey: "name") // 이름
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender") // 성별
        self.married.isOn = plist.bool(forKey: "married") // 결혼여부
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
}
