//
//  GraphViewController.swift
//  1_Calculator
//
//  Created by user on 02/12/16.
//  Copyright © 2016 Vasenina. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    var yForX:((x:Double)->Double?)? { didSet {updateUI()}}
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        scale = graphView.scale
        //origin = graphView.graphOrigin
    }
    
   let defaults = NSUserDefaults.standardUserDefaults()
    private struct Keys{
            static let Scale = "GraphViewController.scale"
            static let Origin = "GraphViewController.origin"
    }
    
    var scale: CGFloat{
        get{ return defaults.objectForKey(Keys.Scale) as? CGFloat ?? 20.0 }
        set{ defaults.setObject(newValue, forKey: Keys.Scale)}
    }
    
    var origin: CGPoint{
        get{ return defaults.objectForKey(Keys.Origin) as? CGPoint ?? CGPoint(x:graphView.bounds.size.width/2, y:graphView.bounds.size.height/2) }
        set{ defaults.setObject([newValue.x, newValue.y], forKey: Keys.Origin)}
    }

   
    @IBOutlet weak var graphView: GraphView!{
        didSet{
            
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: #selector(graphView.changeScale(_:))))//#selector (FaceView.changeScale(_:))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: #selector(graphView.originMove(_:))))
            updateUI()
            
            let doubleGestureRecognizer = UITapGestureRecognizer(target: graphView, action: #selector(graphView.originSet(_:)))
            doubleGestureRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleGestureRecognizer)
            
            graphView.scale = scale
           // graphView.graphOrigin = origin
            
        }
    }
    
    private func updateUI(){
        graphView?.yForX = yForX
        //count model here
        
    }

   

}
