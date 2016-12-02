//
//  GraphViewController.swift
//  1_Calculator
//
//  Created by user on 02/12/16.
//  Copyright © 2016 Vasenina. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    @IBOutlet weak var graphView: GraphView!{
        didSet{
            
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "changeScale:"))//#selector (FaceView.changeScale(_:))
            updateUI()
        }
    }
    
    private func updateUI(){
        //count model here
        
    }

   

}
