//
//  ViewController.swift
//  NetworkPractice
//
//  Created by 정성훈 on 2021/03/26.
//

import UIKit
import Alamofire
import Foundation
class ArticleListViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?
    private var isLoading = false {
        didSet {
            if self.isLoading == true {
                self.loadingIndicator?.startAnimating()
            } else {
                self.loadingIndicator?.stopAnimating()
            }
        }
    }
    private let url = "https://test.spaceflightnewsapi.net/api/v2/articles"
    @IBAction func getArticleList() {
        // TODO:- 백그라운드에서 돌렸는데, UI가 정상적으로 수정되는 이유 찾아보기(메인 큐 밖)
        // 아마 AF가 메인큐에서 실행되는 듯? 편의상 이렇게 구현했나..?
        DispatchQueue.global(qos: .background).async { [weak self] in
            DispatchQueue.main.async {
                self?.isLoading = true;
            }
            AF.request(self?.url ?? "").responseJSON { response in
                self?.isLoading = false
                
                // response.data는 Data?
                // response.value 는 response.result의 associative value이다. Any 타입이니
                // JSONSerialization으로 직렬화할 것.
                switch response.result {
                case .success(let value):
                    if let result = value as? [[String: Any]] {
                        self?.articleLabel?.text = String(result.count)
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
                    
                case .failure:
                    print("error!")
                }
            }
        }
        
    }
    @IBOutlet weak var articleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
    }


}

