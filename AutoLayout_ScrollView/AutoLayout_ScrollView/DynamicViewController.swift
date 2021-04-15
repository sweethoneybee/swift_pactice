//
//  DynamicViewController.swift
//  AutoLayout_ScrollView
//
//  Created by 정성훈 on 2021/04/15.
//

import UIKit

class DynamicViewController: UIViewController {

    @IBOutlet var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addView() {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.isHidden = true;
        label.text = """
            dsafasdf
            sdafasdfasdf
            sdfasdfasdf
            sfasfa
            """
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        self.stackView.addArrangedSubview(label)
        
        UIView.animate(withDuration: 0.3) {
            label.isHidden = false
        }
    }
    
    @IBAction func removeView() {
        guard let last = self.stackView.arrangedSubviews.last else {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            last.isHidden = true
        }) { _ in
            self.stackView.removeArrangedSubview(last)
        }
    }

}
