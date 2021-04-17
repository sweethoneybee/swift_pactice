//
//  ViewController.swift
//  AutoLayout_SelfSizingTableVIew
//
//  Created by 정성훈 on 2021/04/17.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
        
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("layoutCell"),
                                               object: nil,
                                               queue: .main,
                                               using: { noti in
//                                                self.tableView.beginUpdates()
//                                                self.tableView.endUpdates()
                                                self.tableView.performBatchUpdates(nil)
                                               })
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let customCell = cell as? CustomTableViewCell else {
            return cell
        }
        
        customCell.titleLabel?.text = indexPath.description
        customCell.postLabel?.text = """
            dsafasdfasdf
            dasfadsfasdf
            sadfsdfd fsdf dsf sdf dsf d geg trbr
            dsafasdfasdf
            dasfadsfasdf
            sadfsdfd fsdf dsf sdf dsf d geg trbr
            """
        customCell.myImageView?.image = UIImage(named: "\(indexPath.row % 3)")
        return cell;
    }
    
    
}

