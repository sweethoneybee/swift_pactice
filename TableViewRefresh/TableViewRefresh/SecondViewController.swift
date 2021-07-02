//
//  SecondViewController.swift
//  TableViewRefresh
//
//  Created by 정성훈 on 2021/06/30.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onNotiButton(_ sender: Any) {
        NotificationCenter.default.post(name: .refreshNotification, object: nil)
    }
    
    @IBAction func onAddUserButton(_ sender: Any) {
        DBManager.shared.insertPerson(person: Person(profileImageURL: URL(string: "www.naver.com")!, name: "이데이터는", description: "안쓸겨ㅋ"))
    }
}
