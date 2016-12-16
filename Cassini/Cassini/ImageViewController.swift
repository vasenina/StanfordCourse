//
//  ImageViewController.swift
//  Cassini
//
//  Created by user on 14/12/2016.
//  Copyright © 2016 Vasenina. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController , UIScrollViewDelegate{

    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            // fire up the spinner
            // because we're about to fork something off on another thread
            spinner?.startAnimating()
            
            DispatchQueue.global(qos: .userInitiated).async {
                let contentsOfURL = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if url == self.imageURL {
                        if let imageData = contentsOfURL {
                            self.image = UIImage(data: imageData)
                            // image's set will stop the spinner animating
                        } else {
                            self.spinner?.stopAnimating()
                        }
                    } else {
                        // just so you can see in the console when this happens
                        print("ignored data returned from url \(url)")
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
  
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        

        // Do any additional setup after loading the view.
    }

  
    

    
}
