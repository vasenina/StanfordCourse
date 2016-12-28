//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Yulia Vasenina on 28/12/2016.
//  Copyright © 2016 Vasenina. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var imageUrl: URL? {
        didSet {updateUI()}
    }
    
    private func updateUI() {
        if let url = imageUrl {
            spinner?.startAnimating()
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                let contentsOfURL = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    if url == self.imageUrl {
                        if let imageData = contentsOfURL {
                            
                            self.tweetImage?.image = UIImage(data: imageData)
                        }
                        self.spinner?.stopAnimating()
                    }
                }
            }
        }
    }
    
    
}
