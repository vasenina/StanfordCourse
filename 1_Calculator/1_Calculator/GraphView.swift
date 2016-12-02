//
//  GraphView.swift
//  1_Calculator
//
//  Created by user on 02/12/16.
//  Copyright © 2016 Vasenina. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {

    @IBInspectable
    var scale : CGFloat = 1 { didSet{ setNeedsDisplay() } }
    
    var graphOrigin: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    
    func changeScale(recognizer:UIPinchGestureRecognizer){
        switch recognizer.state{
        case .Changed,.Ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }

    
    override func drawRect(rect: CGRect) {
        // Drawing code
        //AxesDrawer(contentScaleFactor: contentScaleFactor).drawAxesInRect(bounds, origin: graphOrigin, pointsPerUnit: scale)
        
    }

}
