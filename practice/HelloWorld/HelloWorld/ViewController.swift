//
//  ViewController.swift
//  HelloWorld
//
//  Created by 정성훈 on 2020/12/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var uiTitle: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func sayHello(_ sender: Any) {
        self.uiTitle.text = "Hello, World!"
    }

}

