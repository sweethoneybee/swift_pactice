//
//  MenuButton.swift
//  AutoLayout_FloatingButtons
//
//  Created by 정성훈 on 2021/04/17.
//

import UIKit

class MenuButton: UIView {
    
    private var menuButton: UIButton!
    private var menuStack: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.addMenuButton()
        self.addMenuStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MenuButton {
    private func addMenuButton() {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "tray", withConfiguration: UIImage.SymbolConfiguration(textStyle: .largeTitle))
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(button)
        self.menuButton = button
        
        let buttonTopConstraint = button.topAnchor.constraint(equalTo: topAnchor)
        buttonTopConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            buttonTopConstraint,
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        button.addTarget(self, action: #selector(tapMenuButton), for: .touchUpInside)
    }

    @objc private func tapMenuButton() {
        UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.9) {
            self.menuStack.arrangedSubviews.forEach { button in
                button.isHidden = !button.isHidden
            }
            
            self.menuStack.layoutIfNeeded()
        }.startAnimation()
        
        
    }
    
    private func addMenuStack() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let imageNames = ["pencil.circle", "paperplane", "folder", "person"]
//        let imageNames = ["tray", "tray", "tray", "tray"]
        imageNames.forEach { imageName in
            let button = UIButton(type: .system)
            let image = UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(textStyle: .largeTitle))
            button.setImage(image, for: .normal)
            button.tintColor = .brown
            button.isHidden = true
            stack.addArrangedSubview(button)
        }
        
        addSubview(stack)
        self.menuStack = stack
        
        let stackTopConstraint = stack.topAnchor.constraint(equalTo: topAnchor)
        stackTopConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            stackTopConstraint,
            stack.bottomAnchor.constraint(equalTo: self.menuButton.topAnchor),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

}
