//
//  ArticleListTableViewController.swift
//  NetworkPractice
//
//  Created by 정성훈 on 2021/04/02.
//

import UIKit
import Alamofire

class ArticleListTableViewController: UITableViewController {
    private var articleList = [Article]()

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
//                        self?.articleLabel?.text = String(result.count)
                        var articles = [Article]()
                        for item in result {
                            if let jsonData = try? JSONSerialization.data(withJSONObject: item, options: []), let json = try? JSONDecoder().decode(Article.self, from: jsonData) {
//                                print(json)
                                articles.append(json)
                            } else {
                                print("string fail")
                            }
                        }
                        self?.articleList = articles
                        self?.tableView.reloadData()
                    } else {
                        print("실패")
                    }
                    
                case .failure:
                    print("error!")
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath)
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") else {
//            print("실패")
//            return UITableViewCell()
//        }
        let article = self.articleList[indexPath.row]
        cell.largeContentTitle = article.title
        cell.detailTextLabel?.text = article.summary
        

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
