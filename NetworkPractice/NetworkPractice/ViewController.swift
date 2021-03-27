//
//  ViewController.swift
//  NetworkPractice
//
//  Created by 정성훈 on 2021/03/26.
//

import UIKit
import Alamofire
import Foundation

struct Article: Codable {
    var id: String
    var featured: Bool
    var title: String
    var url: String
    var imageUrl: String
    var newsSite: String
    var summary: String
    var publishedAt: String // ?
    var launches: [Launch]
    var events: [Event]
}

struct Launch: Codable {
    var id: String
    var provider: String
}

struct Event: Codable {
    var id: String
    var provide: String
}


class ViewController: UIViewController {
    @IBOutlet weak var articleLabel: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = "https://test.spaceflightnewsapi.net/api/v2/articles"

        AF.request(url).responseJSON { response in
            // response.data는 Data?
            // response.value 는 response.result의 associative value이다. Any 타입이니
            // JSONSerialization으로 직렬화할 것.
            switch response.result {
            case .success(let value):
                if let result = value as? [[String: Any]] {
                    self.articleLabel?.text = String(result.count)
                    for item in result {
                        if let jsonData = try? JSONSerialization.data(withJSONObject: item, options: []), let json = try? JSONDecoder().decode(Article.self, from: jsonData) {
                            print(json)
                        } else {
                            print("string fail")
                        }
                    }
                } else {
                    print("실패")
                }
                
            case .failure(let error):
                print("error!")
            default:
                ()
            }
        }
    }


}

