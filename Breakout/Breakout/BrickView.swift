//
//  BrickView.swift
//  Breakout
//
//  Created by Yulia Vasenina on 05/01/2017.
//  Copyright © 2017 Yulia Vasenina. All rights reserved.
//

import UIKit

class BrickView: UIView {

    private struct Constants{
        static let corner: CGFloat  = 2.0
        static let backgroundColor = UIColor.blue
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        self.layer.cornerRadius = Constants.corner
        self.backgroundColor = Constants.backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
