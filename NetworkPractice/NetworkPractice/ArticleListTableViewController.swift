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
        // 답: AF는 비동기로 요청을 날리기 때문에, DispatchQueue로 감쌀 필요가 없음
        // 그리고 기본적으로 response는 main queue에서 처리됨.
            self.isLoading = true;
            AF.request(self.url).responseJSON { response in
                self.isLoading = false
                
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
                        self.articleList = articles
                        self.tableView.reloadData()
                    } else {
                        print("실패")
                    }
                    
                case .failure:
                    print("error!")
                }
            }
    }
    
    @IBAction func addDummy(_ sender: Any) {
        let dummyArticle = Article(id: "12314", featured: true, title: "더미타이틀", url: "dummy", imageUrl: "dummy", newsSite: "dummy", summary: "이것은 더미 디테일이고 이 문장은 의미가 없습니다", publishedAt: "dummy", launches: [Launch(id: "dummy", provider: "dummy")], events: [Event(id: "dummy", provide: "dummy")])
        
        self.articleList.append(dummyArticle)
        self.articleList.remove(at: 0)
        self.tableView.performBatchUpdates({
            self.tableView.insertRows(at: [IndexPath(row: articleList.count - 1, section: 0)], with: .automatic)
            self.tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }, completion: nil)
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
        let article = self.articleList[indexPath.row]
        
        cell.textLabel?.text = article.title
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
