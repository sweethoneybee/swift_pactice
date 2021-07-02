//
//  ViewController.swift
//  TableViewRefresh
//
//  Created by 정성훈 on 2021/06/28.
//

import UIKit
import KakaoSDKAuth
import Alamofire
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users: [User]! = User.fetchAll(context: DBManager.shared.context) ?? [User]()
    
    private var cachedImage = [URL: UIImage]()
    lazy private var fetchedUsersController: NSFetchedResultsController<NSFetchRequestResult> = {
        var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "User", in: DBManager.shared.context)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        fetchRequest.predicate = NSPredicate(format: "", <#T##args: CVarArg...##CVarArg#>)
        fetchRequest.predicate = NSPredicate()
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: DBManager.shared.context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefreshControl), name: .refreshNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        if AuthApi.isKakaoTalkLoginAvailable() {
            AuthApi.shared.loginWithKakaoTalk { token, error in
                if let error = error {
                    print("error: \(error)")
                }
                else {
                    print("token: \(String(describing: token))")
                }
            }
        }
    }
    
    @IBAction func onSecondVCButton(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "SecondViewController")
        self.present(vc, animated: true)
    }
    
    @IBAction func onDeleteAllButton(_ sender: Any) {
        DBManager.shared.deleteAll()
    }
}

extension ViewController {
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        print("handleRefreshControl 호출")
//        self.users.shuffle()
        self.users = User.fetchAll(context: DBManager.shared.context)
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath)
                as? UserTableViewCell else {
            return UITableViewCell()
        }
        
        let user = users[indexPath.row]
        cell.nameLabel.text = user.name
        cell.descriptionLabel.text = user.desc
        
        let key = URL(string: user.profileImageUrl!)!
        if let image = self.cachedImage[key] {
            DispatchQueue.main.async {
                cell.profileImageView.image = image
            }
        }
        else {
            AF.request(key).response { [weak self] response in
                guard let self = self, let data = response.data else { return }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.cachedImage[key] = image
                    cell.profileImageView.image = UIImage(data: data)
                }
            }
        }

//        let key = user.profileImageURL
//        if let image = self.cachedImage[key] {
//                cell.profileImageView.image = image
//        }
//        else {
//            DispatchQueue.global(qos: .background).async { [weak self] in
//                guard let self = self else { return }
//                let data = try! Data(contentsOf: key)
//                DispatchQueue.main.async {
//                    let image = UIImage(data: data)
//                    self.cachedImage[key] = image
//                    cell.profileImageView.image = UIImage(data: data)
//                }
//            }
//        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("델리게이트 호출")
        self.users = User.fetchAll(context: DBManager.shared.context)
        tableView.reloadData()
    }
}
