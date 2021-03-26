//
//  ViewController.swift
//  NetworkPractice
//
//  Created by 정성훈 on 2021/03/26.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var article: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "https://test.spaceflightnewsapi.net/api/v2/articles"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
            case .success(let error):
                print("error!")
            default:
                ()
            }
        }
    }


}

