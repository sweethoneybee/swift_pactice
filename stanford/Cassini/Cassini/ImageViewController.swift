//
//  ViewController.swift
//  Cassini
//
//  Created by 정성훈 on 2021/03/12.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    var imageURL: URL? {
        didSet {
            self.image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private func fetchImage() {
        if let url = self.imageURL {
            self.spinner?.startAnimating()
            DispatchQueue.global(qos: .utility).async {
                let contentsOfURL = try? Data(contentsOf: url)
                DispatchQueue.main.async { [weak weakSelf = self] in
                    if url == weakSelf?.imageURL { // for fine multithreading
                        if let imageData = contentsOfURL {
                            weakSelf?.image = UIImage(data: imageData)
                        } else {
                            weakSelf?.spinner?.stopAnimating()
                        }
                    }
                }
                
            }
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView? {
        didSet {
            scrollView?.contentSize = self.imageView.frame.size
            scrollView?.delegate = self
            scrollView?.minimumZoomScale = 0.03
            scrollView?.maximumZoomScale = 1.0
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue
            self.imageView.sizeToFit()
            self.scrollView?.contentSize = self.imageView.frame.size
            self.spinner?.stopAnimating()
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView?.addSubview(self.imageView)
    }


}

