//
//  ViewController.swift
//  AutoLayout_FloatingButtons
//
//  Created by 정성훈 on 2021/04/17.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuButton = MenuButton()
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(menuButton)
        menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        menuButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }


}

