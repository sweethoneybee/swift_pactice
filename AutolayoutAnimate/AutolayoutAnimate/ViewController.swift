//
//  ViewController.swift
//  AutolayoutAnimate
//
//  Created by 정성훈 on 2021/09/08.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var redView: UIView!
    var redViewHeightConstraint: Constraint?
    var heightButton: UIButton!
    var toggle: Bool = true
    
    private let shortHeight = CGFloat(50)
    private let longHeight = CGFloat(150)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setConstraints()
    }

    @objc
    func updateRedViewHeight() {
        if toggle {
            self.redViewHeightConstraint?.update(offset: shortHeight)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            toggle.toggle()
            return
        }
        
        self.redViewHeightConstraint?.update(offset: longHeight)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        toggle.toggle()
    }
    
    func setViews() {
        redView = {
            $0.backgroundColor = .red
            $0.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
            self.view.addSubview($0)
            return $0
        }(UIView())
        
        heightButton = {
            $0.setTitle("높이 바꾸기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 10
            $0.sizeToFit()
            $0.addTarget(self, action: #selector(updateRedViewHeight), for: .touchUpInside)
            self.view.addSubview($0)
            return $0
        }(UIButton(type: .system))
    }
    
    func setConstraints() {
        redView.snp.makeConstraints { make in
            make.centerX.equalTo(heightButton)
            make.top.equalTo(heightButton.snp.bottom).offset(30)
            make.width.equalTo(shortHeight)
            redViewHeightConstraint = make.height.equalTo(shortHeight).constraint
        }
        
        heightButton.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.equalTo(100)
            make.height.equalTo(heightButton.snp.width).multipliedBy(0.5)
        }
    }
    
//    func oldSetConstraint() {
//                redViewHeightConstraint = redView.heightAnchor.constraint(equalToConstant: 50)
//                NSLayoutConstraint.activate([
//                    redView.centerXAnchor.constraint(equalTo: heightButton.centerXAnchor),
//                    redView.topAnchor.constraint(equalTo: heightButton.bottomAnchor, constant: 30),
//                    redView.widthAnchor.constraint(equalToConstant: 50),
//                    redViewHeightConstraint
//                ])
//
//                NSLayoutConstraint.activate([
//                    heightButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                    heightButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//                    heightButton.widthAnchor.constraint(equalToConstant: 100),
//                    heightButton.heightAnchor.constraint(equalTo: heightButton.widthAnchor, multiplier: 0.5)
//                ])
//    }
}

