//
//  BreakoutGameViewController.swift
//  Breakout
//
//  Created by Yulia Vasenina on 05/01/2017.
//  Copyright © 2017 Yulia Vasenina. All rights reserved.
//

import UIKit

class BreakoutGameViewController: UIViewController {

            
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        breakout.createBricks(arrangement: Levels.levels[0])
        breakout.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(GamePlayView.panPaddle)))
    }
    
    @IBOutlet weak var breakout: GamePlayView!

    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
