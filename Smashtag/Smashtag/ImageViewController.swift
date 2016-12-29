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
    
    @IBAction func toRootViewController(_ sender: UIBarButtonItem) {
        _ = navigationController?.popToRootViewController(animated: true)
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
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        autoZoomed = false
    }
    
    private var autoZoomed = true
    
    //image autosize
    private func zoomScaleToFit()
    {
        if !autoZoomed {
            return
        }
        if let sv = scrollView , image != nil && (imageView.bounds.size.width > 0)
            && (scrollView.bounds.size.width > 0){
            
            let widthRatio = scrollView.bounds.size.width  / imageView.bounds.size.width
            let heightRatio = scrollView.bounds.size.height / self.imageView.bounds.size.height
            sv.zoomScale = (widthRatio > heightRatio) ? widthRatio : heightRatio
            sv.contentOffset = CGPoint(x: (imageView.frame.size.width - sv.frame.size.width) / 2,
                                       y: (imageView.frame.size.height - sv.frame.size.height) / 2)
        }
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
            autoZoomed = true
            zoomScaleToFit()
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        zoomScaleToFit()
    }
  
    

    
}
