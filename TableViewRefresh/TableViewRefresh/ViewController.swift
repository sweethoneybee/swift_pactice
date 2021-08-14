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

    private var isRefreshing = false
    private var cachedImage = [URL: UIImage]()
    lazy private var fetchedUsersController: NSFetchedResultsController<User> = {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchedResultsController: NSFetchedResultsController<User>!
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: DBManager.shared.context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
        try? fetchedUsersController.performFetch()
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefreshControl), name: .refreshNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        print("리프리세 시작")
        reloadData()
        endRefreshing()
//        Timer.scheduledTimer(withTimeInterval: TimeInterval(0.1), repeats: false) { [weak self] _ in
//            self?.tableView?.refreshControl?.endRefreshing()
//            print("타이머 호출!")
//        }
//        print("리프리세 끝")
    }
    
    @objc func endRefreshing() {
        self.tableView.refreshControl?.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 0.1)
    }
    
    // MARK: - Interface Builder
    @IBOutlet weak var tableView: UITableView!
    
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
        reloadData()
    }
    
    @IBAction func onAddUserButton(_ sender: Any) {
        DBManager.shared.insertPerson()
    }
    
    private func reloadData() {
        try? fetchedUsersController.performFetch()
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedUsersController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath)
                as? UserTableViewCell else {
            return UITableViewCell()
        }
        
        let user = fetchedUsersController.object(at: indexPath)
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
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("델리게이트 호출")
        
        reloadData()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("didChange at indexPath 델리게이트 호출")

        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        default:
            break
        }
        
        tableView.scrollToRow(at: newIndexPath!, at: .bottom, animated: true)
        tableView.visibleCells.forEach { cell in
            guard let cell = cell as? UserTableViewCell, let newIndexPath = newIndexPath,
                  let newCell = tableView.cellForRow(at: newIndexPath) as? UserTableViewCell else { return }
            
            if cell.nameLabel.text == newCell.nameLabel.text {
                print("보였다! 셀의 실!")
            }
        }
    }
}
