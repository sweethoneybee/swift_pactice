//
//  ViewController.swift
//  recognizerTest
//
//  Created by 정성훈 on 2021/07/22.
//

import UIKit

class ViewController: UIViewController {

    let firstView = UIView()
    let secondView = UIView()
    let containerView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        
        view.addSubview(containerView)
        containerView.frame = CGRect(x: 10, y: 10, width: 400, height: 500)
        containerView.backgroundColor = .green
        
        firstView.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        firstView.backgroundColor = .red
        firstView.addGestureRecognizer(gesture)
        containerView.addSubview(firstView)
        
        secondView.frame = CGRect(x: 50, y: 300, width: 100, height: 100)
        secondView.backgroundColor = .blue
        secondView.addGestureRecognizer(gesture) // 얘가 제스쳐 뺏어감
        containerView.addSubview(secondView)
        
    }
    
    @objc
    func longPressed(_ sender: UIGestureRecognizer) {
        NSLog("제스처 인식됨. sender=\(sender.description)")
    }

}

