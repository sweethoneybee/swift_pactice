//
//  ViewController.swift
//  DispatchWorkItemExample
//
//  Created by 정성훈 on 2021/08/04.
//
// 코드 참고
// https://medium.com/remember/gcd-4-dispatchworkitem-8b146b020101

import UIKit
import Foundation

class ViewController: UIViewController {

    var searchRequestWorkItem: DispatchWorkItem?
    
    
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func searchMock(text: String) {
        searchRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem {
            print("\(text)를 가지고 검색 수행")
        }
        
        searchRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: requestWorkItem)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc
    func textFieldDidChange(_ notification: Notification) {
        guard let text = textField.text else { return }
        searchMock(text: text)
    }
}
