//
//  CassiniViewController.swift
//  Cassini
//
//  Created by 정성훈 on 2021/03/12.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {
    private struct StoryBoard {
        static let ShowImageSugue = "Show Image"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryBoard.ShowImageSugue {
            if let ivc = segue.destination.contentViewController as? ImageViewController {
                let imageName = (sender as? UIButton)?.currentTitle
                ivc.imageURL = DemoURL.NASAImageNamed(imageName: imageName)
                ivc.title = imageName
            }
        }
    }
    
    @IBAction func showImage(_ sender: UIButton) {
        if let ivc = splitViewController?.viewControllers.last?.contentViewController as? ImageViewController {
            let imageName = sender.currentTitle
            ivc.imageURL = DemoURL.NASAImageNamed(imageName: imageName)
            ivc.title = imageName
        } else {
            performSegue(withIdentifier: StoryBoard.ShowImageSugue, sender: sender)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contentViewController == self {
            if let ivc = secondaryViewController as? ImageViewController, ivc.imageURL == nil {
                return true
            }
        }
        return false
    }
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
