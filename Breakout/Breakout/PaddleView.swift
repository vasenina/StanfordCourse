//
//  PaddleView.swift
//  Breakout
//
//  Created by Yulia Vasenina on 04/02/2017.
//  Copyright © 2017 Yulia Vasenina. All rights reserved.
//

import UIKit

class PaddleView: UIView {

    private struct Constants {
        static let backgroundColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0)
        static let cornerRadius: CGFloat = 2.0
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.backgroundColor = Constants.backgroundColor
        self.layer.cornerRadius = Constants.cornerRadius
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
