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
    
    @IBInspectable
    var lineWidth: CGFloat = 2.0 { didSet{ setNeedsDisplay() } }
    
    @IBInspectable
    var color: UIColor = UIColor.blackColor() { didSet{ setNeedsDisplay() } }
    
    private var originSet: CGPoint?  { didSet{ setNeedsDisplay() } }
    
    var graphOrigin: CGPoint {
        get{
            return originSet ?? convertPoint(center, fromView: superview)
            //return convertPoint(center, fromView: superview)
        }
        set{
            originSet = newValue
        }
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
    
    func originMove(recognizer:UIPanGestureRecognizer){
        switch recognizer.state{
        case .Ended: fallthrough
        case .Changed,.Ended:
            let translation = recognizer.translationInView(self)
            if translation != CGPointZero{
                graphOrigin.x += translation.x
                graphOrigin.y += translation.y
                recognizer.setTranslation(CGPointZero, inView: self)
            }
        default: break
        }
    }
    
    func originSet(recognizer:UITapGestureRecognizer){
        if recognizer.state == .Ended{
            graphOrigin = recognizer.locationInView(self)
        }
    }


    
    override func drawRect(rect: CGRect) {
        // Drawing code
        AxesDrawer(contentScaleFactor: contentScaleFactor).drawAxesInRect(bounds, origin: graphOrigin, pointsPerUnit: scale)
        
    }

}
