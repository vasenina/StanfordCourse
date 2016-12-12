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
    
    
    var yForX: ((x:Double)->Double?)? { didSet{ setNeedsDisplay() } }
    
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
        case .Began:
            drawGraph = true
            snapShot = self.snapshotViewAfterScreenUpdates(false)
            snapShot!.alpha = 0.5
            self.addSubview(snapShot!)
            
        case .Changed:
            let translation = recognizer.translationInView(self)
            if translation != CGPointZero{
                // screenshot mooving
                snapShot!.center.x += translation.x
                snapShot!.center.y += translation.y
                // OR axes mooving
                //graphOrigin.x += translation.x
                //graphOrigin.y += translation.y
                recognizer.setTranslation(CGPointZero, inView: self)
            }

        case .Ended:
            graphOrigin.x += snapShot!.frame.origin.x
            graphOrigin.y += snapShot!.frame.origin.y
            snapShot!.removeFromSuperview()
            drawGraph = false
            setNeedsDisplay()
            
        default: break
        }
    }
    
    func originSet(recognizer:UITapGestureRecognizer){
        if recognizer.state == .Ended{
            graphOrigin = recognizer.locationInView(self)
        }
    }
    
    private struct OldPoint{
        var yGraph: CGFloat
        var normal: Bool
    }

    func drawGraphinRect(bounds:CGRect, origin: CGPoint, scale: CGFloat){
        color.set()
        
        var xGraph, yGraph: CGFloat
        var x:Double { return Double ((xGraph-origin.x) / scale)}
        
        var oldPoint = OldPoint(yGraph: 0.0, normal: false)
        var disContinuity: Bool{return abs(yGraph-oldPoint.yGraph)>max(bounds.width, bounds.height) * 1.5}
        
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        
        for i in 0...Int(bounds.size.width*contentScaleFactor){
            xGraph = CGFloat(i) / contentScaleFactor
            
            guard let y = (yForX)?(x:x) where y.isFinite else { oldPoint.normal = false; continue }
            yGraph = origin.y - CGFloat(y)*scale
            
            if !oldPoint.normal{
                path.moveToPoint(CGPoint(x:xGraph, y: yGraph))
            }
            else{
                guard !disContinuity
                else{
                    oldPoint = OldPoint(yGraph: yGraph, normal:false)
                    continue}
                path.addLineToPoint(CGPoint(x:xGraph, y: yGraph))
            }
            oldPoint = OldPoint(yGraph: yGraph, normal: true)
        }
        path.stroke()
        
    }
    
    private var drawGraph: Bool = false
    private var snapShot: UIView?
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        AxesDrawer(contentScaleFactor: contentScaleFactor).drawAxesInRect(bounds, origin: graphOrigin, pointsPerUnit: scale)
        if !drawGraph{
            drawGraphinRect(bounds, origin: graphOrigin , scale: scale)
        }
    }

}
